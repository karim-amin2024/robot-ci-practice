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
    [Arguments]     ${username}     ${password}      ${expected_status}    ${response_failure_details}=${None}
    ${body}=         Create Dictionary    username=${username}    password=${password}
    ${response}=     POST                 url=${application_endpoint_url}/login         json=${body}        expected_status=${expected_status}
    IF     ${response.status_code} == 200
        RETURN     ${response.json()}[token]
    ELSE
        Should Be Equal           ${response.json()}[detail]        ${response_failure_details}
    END

Login to the server with missing credintials
    [Documentation]  This keyword login injects the missing credintials issue based on the input missing flags
    [Arguments]    ${username}     ${password}    ${expected_status}    ${Missing_username_flag}=False    ${Missing_password_flag}=False     
    IF         ${Missing_username_flag} == True
        ${body}=         Create Dictionary    password=${password}
    ELSE IF     ${Missing_password_flag} == True
        ${body}=         Create Dictionary    username=${username} 
    ELSE 
        ${body}=         Create Dictionary    username=${username}    password=${password}
    END
    ${response}=     POST                 url=${application_endpoint_url}/login         json=${body}        expected_status=${expected_status}
    Should Be Equal     ${response.json()}[detail][0][msg]    Field required
    IF         ${Missing_username_flag} == True
        Should Be Equal     ${response.json()}[detail][0][loc][1]    username
    ELSE IF     ${Missing_password_flag} == True
        Should Be Equal     ${response.json()}[detail][0][loc][1]    password
    END
     
Register New User to the Server Data base
    [Documentation]  This keyword is for creating a new user credintials and add it to the data base
    [Arguments]    ${username}     ${password}    ${expected_status}     ${Missing_username_flag}=False
    IF     ${Missing_username_flag}==False
        ${body}=        Create Dictionary    username=${username}    password=${password}
    ELSE 
        ${body}=        Create Dictionary    password=${password}
    END
    ${response}=    POST                url=${application_endpoint_url}/register        json=${body}        expected_status=${expected_status}
    # Assert on the return username which was created and stored in the server
    IF    ${Missing_username_flag}==False
        Should Be Equal     ${response.json()}[username]       ${username}  
    END