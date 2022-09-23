*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${login_button}  //button[@id='dt_login_button']
${login_form_button}  //button[@type='submit']
${email_field}  //input[@id='txtEmail']
${email}
${password_field}  //input[@id='txtPass']
${password}
${account_info}  //div[@id='dt_core_account-info_acc-info']
${real_tab}  //li[@id='real_account_tab']
${purchase_call_button}  //button[@id='dt_purchase_call_button']
${purchase_put_button}  //button[@id='dt_purchase_put_button']
${demo_tab}  //li[@id='dt_core_account-switcher_demo-tab']
${account_settings_icon}  //a[@class='account-settings-toggle']

*** Keywords ***
Login To Deriv
    Open Browser  https://app.deriv.com  chrome
    Maximize Browser Window
    Wait Until Page Contains Element  ${purchase_call_button}  200
    Click Element  ${login_button} 
    Wait Until Page Contains Element  ${email_field}  200
    Input Text  ${email_field}  ${email}
    Input Text  ${password_field}  ${password}
    Click Element  ${login_form_button}
    Wait Until Page Contains Element  ${purchase_call_button}  200

Check the Current Account Lands on Real Account
    # Count number of notifications
    ${notification_count}=    Get Element Count   //button[@class='notification__close-button']

    IF  ${notification_count} > 0
        # Close all notifications
        FOR  ${index}  IN RANGE  1  ${notification_count}
            Click Element    //button[@class='notification__close-button']  
        END
    END
    
    Click Element  ${account_info}
    Page Should Contain Element  ${real_tab}

Switch to Virtual Account and Verify Virtual Account is Displayed
    Click Element  ${demo_tab}
    Page Should Contain Element  //*[contains(text(),'Demo') and .//div[contains(@class, 'acc-switcher__loginid-text')]]
    Click Element  //div[contains(@class, 'acc-switcher__accounts')]
    Wait Until Page Contains Element  //span[contains(@class, 'trade-container__price-info-currency')]  200

Close Account Without Selecting Any Reason
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_close-your-account_link']
    Wait Until Page Contains Element  //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']  50
    Click Element  //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']
    Wait Until Page Contains Element  //p[@class='dc-text closing-account-reasons__title']  50
    Element Should Be Disabled  //button[@type='submit' and .//span[contains(text(), 'Continue')]]

Cancel Account Closing
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_close-your-account_link']
    Wait Until Page Contains Element  //button[@class='dc-btn dc-btn--secondary dc-btn__large closing-account__button--cancel']  50
    Click Element  //button[@class='dc-btn dc-btn--secondary dc-btn__large closing-account__button--cancel']
    Wait Until Page Contains Element  //span[contains(@class, 'trade-container__price-info-currency')]  200

Check Response After Clicking Back Button in Reasons to Close Account Page
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_close-your-account_link']
    Wait Until Page Contains Element  //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']  50
    Click Element  //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']
    Wait Until Page Contains Element  //button[@type='button' and .//span[contains(text(), 'Back')]]  50
    Click Element  //button[@type='button' and .//span[contains(text(), 'Back')]]
    Wait Until Page Contains Element  //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']  50

Check Security and Privacy Policy Link Points to the Correct PDF File
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_close-your-account_link']
    Wait Until Page Contains Element  //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']  50
    Page Should Contain Element  //a[@href='https://deriv.com/tnc/security-and-privacy.pdf' and contains(text(), 'Security and privacy policy')]

Close Account With Multiple Reasons
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_close-your-account_link']
    Wait Until Page Contains Element  //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']  50
    Click Element  //button[@class='dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account']
    Wait Until Page Contains Element  //p[@class='dc-text closing-account-reasons__title']  50
    Click Element  (//span[@class='dc-text dc-checkbox__label'])[1]
    Click Element  (//span[@class='dc-text dc-checkbox__label'])[2]
    Click Element  (//span[@class='dc-text dc-checkbox__label'])[3]
    Click Element  //button[@type='submit' and .//span[contains(text(), 'Continue')]]
    Wait Until Page Contains Element  //button[@type='submit' and .//span[contains(text(), 'Close account')]]  50
    Click Element  //button[@type='submit' and .//span[contains(text(), 'Close account')]]
    Wait Until Page Contains Element  //p[@class="dc-text account-closed"]

*** Test Cases ***
Account Closing
    Login To Deriv
    Check the Current Account Lands on Real Account
    Switch to Virtual Account and Verify Virtual Account is Displayed
    Close Account Without Selecting Any Reason
    Cancel Account Closing
    Check Response After Clicking Back Button in Reasons to Close Account Page
    Check Security and Privacy Policy Link Points to the Correct PDF File
    Close Account With Multiple Reasons