*** Settings ***
Resource           ../resources/API.resource
Resource           ../resources/Common/APICommon.resource


# Global test setup and teardown runs only once 
Suite Setup       Start the API Server for hosting the app
Suite Teardown    Stop the API Server that hosts the app

*** Variables ***
${Valid_username}=     alice
${Valid_password}=     secret
${E_OK}=               200
*** Test Cases ***
Verify the Server Health while running
    [Tags]    smoke    001    
    [Documentation]    
    Connect to the Server endpoint
    Check the Server Health    expected_status=${E_OK}

Verify Login with valid credintials
    [Tags]    smoke    002
    Login to the server     username=${Valid_username}     password=${Valid_password}    expected_status=${E_OK}