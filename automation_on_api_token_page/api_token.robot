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

Create API token called 'My API Token' with all scopes
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_api-token_link']
    Wait Until Page Contains Element  //input[@class='dc-input__field' and @name='token_name']  200
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Read')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Payments')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Admin')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Trade')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Trading information')]]
    Press Keys  //input[@class='dc-input__field' and @name='token_name']  CTRL+a+BACKSPACE
    Input Text  //input[@class='dc-input__field' and @name='token_name']  My API Token
    Click Element  //button[@type='submit' and .//span[contains(text(), 'Create')]]

Create API token called 'Another API Token' with no scopes
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_api-token_link']
    Wait Until Page Contains Element  //input[@class='dc-input__field' and @name='token_name']  200
    Press Keys  //input[@class='dc-input__field' and @name='token_name']  CTRL+a+BACKSPACE
    Input Text  //input[@class='dc-input__field' and @name='token_name']  Another API Token
    Element Should Be Disabled  //button[@type='submit' and .//span[contains(text(), 'Create')]]

Create API token called 'Just API Token' with only one scope
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_api-token_link']
    Wait Until Page Contains Element  //input[@class='dc-input__field' and @name='token_name']  200
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Read')]]
    Press Keys  //input[@class='dc-input__field' and @name='token_name']  CTRL+a+BACKSPACE
    Input Text  //input[@class='dc-input__field' and @name='token_name']  Just API Token
    Click Element  //button[@type='submit' and .//span[contains(text(), 'Create')]]

Copy created API token
    Click Element  (//*[@class='dc-icon dc-clipboard'])[1]
        ${status}=    Run Keyword And Return Status  Wait Until Page Contains Element  //span[@class='dc-text dc-popover__bubble__text' and contains(text(), 'Token copied!')]  30
    IF  ${status} is False
        Click Element    //div[@class='dc-modal-footer da-api-token__modal-footer' and .//button/span[contains(text(), 'OK')]]      
    END

Show API token
    Wait Until Page Contains Element  (//*[@data-testid='dt_toggle_visibility_icon'])[1]  200
    Click Element  (//*[@data-testid='dt_toggle_visibility_icon'])[1]
    Wait Until Page Contains Element  //div[@class='da-api-token__clipboard-wrapper' and .//p]  200

Hide API token
    Click Element  (//*[@data-testid='dt_toggle_visibility_icon'])[1]
    Wait Until Page Contains Element  (//div[@class='da-api-token__clipboard-wrapper' and .//div[@class='da-api-token__pass-dot-container']])[1]  200

Delete API token
    Click Element  (//*[@data-testid='dt_token_delete_icon'])[2]
    Wait Until Page Contains Element  //button[@type='submit' and .//span[contains(text(), 'Yes, delete')]]  200
    Click Element  //button[@type='submit' and .//span[contains(text(), 'Yes, delete')]] 
    Wait Until Page Contains Element  //input[@class='dc-input__field' and @name='token_name']  200

Create API tokens with the same names and scopes
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_api-token_link']
    Wait Until Page Contains Element  //input[@class='dc-input__field' and @name='token_name']  200
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Read')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Payments')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Admin')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Trade')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Trading information')]]
    Press Keys  //input[@class='dc-input__field' and @name='token_name']  CTRL+a+BACKSPACE
    Input Text  //input[@class='dc-input__field' and @name='token_name']  More API Token
    Click Element  //button[@type='submit' and .//span[contains(text(), 'Create')]]

    Wait Until Page Contains Element  //tr[.//td/span[contains(text(), 'More API Token')]]  200
    Sleep  2
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Read')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Payments')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Admin')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Trade')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Trading information')]]
    Press Keys  //input[@class='dc-input__field' and @name='token_name']  CTRL+a+BACKSPACE
    Input Text  //input[@class='dc-input__field' and @name='token_name']  More API Token
    Click Element  //button[@type='submit' and .//span[contains(text(), 'Create')]]

    # Count number of API token with name 'More API Token'
    ${same_api_token}=  Get Element Count  //tr[.//td/span[contains(text(), 'More API Token')]]

    # Check that there are only two tokens with name 'More API Token'
    Should Not Be Equal  ${same_api_token}  1


Create API token with invalid format
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_api-token_link']
    Wait Until Page Contains Element  //input[@class='dc-input__field' and @name='token_name']  200
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Read')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Payments')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Admin')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Trade')]]
    Click Element  //div[@class='composite-checkbox api-token__checkbox' and .//span[contains(text(), 'Trading information')]]
    Press Keys  //input[@class='dc-input__field' and @name='token_name']  CTRL+a+BACKSPACE
    Input Text  //input[@class='dc-input__field' and @name='token_name']  A
    Element Should Be Disabled  //button[@type='submit' and .//span[contains(text(), 'Create')]]

Delete All API Tokens
    Click Element  ${account_settings_icon}
    Wait Until Page Contains Element  //label[@for='residence']  200
    Click Element  //a[@id='dc_api-token_link']
    Wait Until Page Contains Element  //input[@class='dc-input__field' and @name='token_name']  200
    # Count number of delete buttons
    ${delete_count}=  Get Element Count  //*[@data-testid='dt_token_delete_icon']
    Log  delete_count ${delete_count}  console=yes

    IF  ${delete_count} > 0
        # Close all notifications
        FOR  ${index}  IN RANGE  1  ${delete_count}
            Wait Until Page Contains Element  (//*[@data-testid='dt_token_delete_icon'])[1]  50
            Click Element  (//*[@data-testid='dt_token_delete_icon'])[1]
            Wait Until Page Contains Element  //button[@type='submit' and .//span[contains(text(), 'Yes, delete')]]  200
            Click Element  //button[@type='submit' and .//span[contains(text(), 'Yes, delete')]] 
            Wait Until Page Contains Element  //input[@class='dc-input__field' and @name='token_name']  200 
        END
    END

*** Test Cases ***
API Token Page
    Login To Deriv
    Check the Current Account Lands on Real Account
    Switch to Virtual Account and Verify Virtual Account is Displayed
    # Delete All API Tokens
    Create API token called 'My API Token' with all scopes
    Create API token called 'Another API Token' with no scopes
    Create API token called 'Just API Token' with only one scope
    Copy created API token
    Show API token
    Hide API token
    Delete API token
    Create API tokens with the same names and scopes
    Create API token with invalid format
    
    