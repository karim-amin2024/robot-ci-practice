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
${Valid_username}=                alice
${Valid_password}=                secret
${new_valid_username}=            karim
${new_valid_password}=            younis123
${Invalid_username}=              wrong
${Invalid_password}=              wrong
${E_OK}=                          200 
${User_Register_E_OK}=            201
${Invalid_userOrPass_E_NOK}=      401
${Invalid_userOrPass_detail}=     Invalid credentials
${Missing_userOrPass_E_NOK}=      422
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
    # Store the generated token after the successful login attempt
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

Verify The Registeration of a new user with valid credintials
    [Tags]    smoke    005
    [Documentation]
    # Register a new user to the server data base
    Register New User to the Server Data base        username=${new_valid_username}     password=${new_valid_password}    expected_status=${User_Register_E_OK}
    # Login with the newly created user to verify the server functionality
    ${Token}=    Login to the server     username=${new_valid_username}     password=${new_valid_password}    expected_status=${E_OK}
    # Store the generated token after the successful login attempt
    Append To List    ${TOKENS}        ${Token}

Verify The Registeration of a new user with missing credintials
    [Tags]    smoke    006
    [Documentation]
    # Register a new user to the server data base
    Register New User to the Server Data base        username=${new_valid_username}     password=${new_valid_password}    expected_status=${Missing_userOrPass_E_NOK}    Missing_username_flag=True
       
    