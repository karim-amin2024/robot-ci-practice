*** Settings ***
Library            Collections
Resource           ../resources/API.resource
Resource           ../resources/Common/APICommon.resource


# Global test setup and teardown runs only once 
Suite Setup       Start the API Server for hosting the app
Suite Teardown    Stop the API Server that hosts the app

*** Variables ***
# a list that holds all generated tokens from the api server
@{TOKENS}    
${Valid_username}=     alice
${Valid_password}=     secret
${Invalid_username}=     wrong
${Invalid_password}=     wrong
${E_OK}=               200 
${Invalid_userOrPass_E_NOK}=     401
${Invalid_userOrPass_detail}=     Invalid credentials
${Missing_userOrPass_E_NOK}=     422
${Missing_userOrPass_detail}=     Invalid credentials
*** Test Cases ***
Verify the Server Health while running
    [Tags]    smoke    001    
    [Documentation]    
    Connect to the Server endpoint
    Check the Server Health    expected_status=${E_OK}

Verify Login with valid credintials
    [Tags]    smoke    002
    [Documentation]
    ${Token}=    Login to the server     username=${Valid_username}     password=${Valid_password}    expected_status=${E_OK}
    Append To List    ${TOKENS}        ${Token}

Verify Login with invalid credintials
    [Tags]    full    003
    [Documentation]
    Login to the server     username=${Invalid_username}     password=${Invalid_password}    expected_status=${Invalid_userOrPass_E_NOK}     response_failure_details=${Invalid_userOrPass_detail}

Verify Login with Missing credintials
    [Tags]    full    004
    [Documentation]
    # test the missing user name usecase
    Login to the server with missing credintials     username=${Valid_username}     password=${Valid_password}    expected_status=${Missing_userOrPass_E_NOK}   Missing_username_flag=True
    Login to the server with missing credintials     username=${Valid_username}     password=${Valid_password}    expected_status=${Missing_userOrPass_E_NOK}   Missing_password_flag=True