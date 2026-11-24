*** Settings ***
Library               RequestsLibrary
*** Variables ***
${application_endpoint_url}         http://127.0.0.1:8000 
${E_OK}                             200      
*** Keywords ***
Connect to the Server endpoint
    Create Session  url= ${application_endpoint_url}  alias= "Testing session"

Check the Server Health
    [Documentation]     Checks the Server Health
    [Arguments]         ${expected_status}
    ${response}=  Get         url=${application_endpoint_url}/health        expected_status=${expected_status}
    Should Be Equal           ${response.json()}[status]    ok

Login to the server
    [Documentation]  This keyword login into the api server with pass credintial based on the use case, then assert on the expected status code finally returns the new token 
    [Arguments]     ${username}     ${password}      ${expected_status}
    ${body}=         Create Dictionary    username=${username}    password=${password}
    ${response}=     POST                 url=${application_endpoint_url}/login         json=${body}        expected_status=${expected_status}
    RETURN     ${response.json()}[token]