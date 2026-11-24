*** Settings ***
Library    Process


*** Keywords ***
Start the API Server for hosting the app
    ${handle}=    Start Process    uvicorn app.main:app --port 8000    shell=True
    Set Suite Variable    ${SERVER_HANDLE}    ${handle}
    # Give Uvicorn a couple of seconds to initialize before tests start
    Sleep    2s

Stop the API Server that hosts the app
    ${pid}=    Get Process Id    ${SERVER_HANDLE}
    Run Process    taskkill    /F    /T    /PID    ${pid}