@echo off
where node >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Node.js not found. Downloading installer...

    curl -o "%TEMP%\node-install.msi" "https://nodejs.org/dist/v20.18.1/node-v20.18.1-x64.msi"
    if %ERRORLEVEL% neq 0 (
        echo Download failed. Please install Node.js manually from https://nodejs.org/
        pause
        exit /b 1
    )

    echo Installing Node.js...
    msiexec /i "%TEMP%\node-install.msi" /qn
    del "%TEMP%\node-install.msi" >nul 2>&1

    echo Node.js installed. Refreshing PATH...
    set "PATH=%PATH%;C:\Program Files\nodejs"
)

echo.
echo Launching Claude Code for authentication...
echo Log in via the browser, then close Claude Code when done.
echo.
npx -y @anthropic-ai/claude-code
