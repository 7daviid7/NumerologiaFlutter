@echo off
rem Navigate to project root if script is run from tools folder
if exist "..\pubspec.yaml" cd ..

echo Loading environment variables...
if exist .env (
    for /f "delims=" %%x in (.env) do set %%x
) else (
    echo WARNING: .env file not found! API key might be missing.
)

echo Cleaning project...
call flutter clean

echo Getting dependencies...
call flutter pub get

echo Building Flutter Web App for Release...
call flutter build web --release --dart-define=GEMINI_API_KEY=%GEMINI_API_KEY%

echo.
echo Deploying to Firebase...
call firebase deploy

echo.
echo Deployment Complete!
pause
