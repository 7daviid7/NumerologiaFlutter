@echo off
echo ==========================================
echo       DESPLEGANT A PRODUCCIO
echo ==========================================

echo 0. Netejant cache...
call flutter clean

echo 1. Construint la web amb la API Key...
call flutter build web --release --dart-define=GEMINI_API_KEY=AIzaSyDjGz2k9FOThaHBhTGwlsTO19EM3DiH00o

if %errorlevel% neq 0 (
    echo [ERROR] La construcció ha fallat!
    exit /b %errorlevel%
)

echo.
echo 2. Pujant a Firebase Hosting...
call firebase deploy

echo.
echo ==========================================
echo            PROCÉS FINALITZAT
echo ==========================================
pause
