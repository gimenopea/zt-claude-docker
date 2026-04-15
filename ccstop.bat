@echo off
for %%I in ("%CD%") do set FOLDER_NAME=%%~nxI
docker stop claude-%FOLDER_NAME% && docker rm claude-%FOLDER_NAME%