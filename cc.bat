@echo off
for %%I in ("%CD%") do set FOLDER_NAME=%%~nxI
set CONTAINER_NAME=claude-%FOLDER_NAME%

:: Write container ID to temp file, read it back
docker ps -q --filter "name=%CONTAINER_NAME%" > %TEMP%\cc_check.txt 2>nul
set /p RUNNING=< %TEMP%\cc_check.txt
del %TEMP%\cc_check.txt >nul 2>&1

if "%RUNNING%"=="" (
    docker run -dit --name %CONTAINER_NAME% ^
      -v "%CD%:/workspace" ^
      -v "%USERPROFILE%\.claude:/home/node/.claude" ^
      -v "%USERPROFILE%\.claude.json:/home/node/.claude.json" ^
      -e PS1="\w \$ " ^
      -w /workspace ^
      claude-code
)

docker exec -it %CONTAINER_NAME% /bin/bash