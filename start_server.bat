@echo off
REM Solar Trailer Analyzer - Auto-start script for Windows

echo Starting Solar Trailer Analyzer...
echo ===================================
echo.

REM Change to the directory where this batch file is located
cd /d "%~dp0"

REM Check if caddy.exe exists
if exist caddy.exe (
    echo Found caddy.exe - Starting portable server...
    echo.
    
    start "Solar Analyzer Server" cmd /k "caddy.exe file-server --listen :8000"
    
    timeout /t 3 /nobreak >nul
    
    echo Opening browser...
    start http://localhost:8000/sun_exposure_map.html
    
    echo.
    echo ===================================
    echo Server is running on port 8000
    echo Close the caddy window to stop
    echo ===================================
    pause
    exit /b 0
)

REM Check if hfs.exe exists
if exist hfs.exe (
    echo Found HFS server...
    echo Please drag sun_exposure_map.html into HFS window
    echo Then right-click and select Open in browser
    start "" hfs.exe
    pause
    exit /b 0
)

REM Check if Python is installed
where python >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Python found! Starting server...
    echo.
    
    REM Start Python server and open browser
    start "Solar Analyzer Server" cmd /k "python -m http.server 8000"
    
    timeout /t 3 /nobreak >nul
    
    echo Opening browser...
    start http://localhost:8000/sun_exposure_map.html
    
    echo.
    echo ===================================
    echo Server is running on port 8000
    echo Close the server window to stop
    echo ===================================
    
) else (
    echo ERROR: No server found!
    echo.
    echo Please download one of these:
    echo.
    echo 1. Caddy - EASIEST - 15MB
    echo    https://caddyserver.com/download
    echo    Save as caddy.exe in this folder
    echo.
    echo 2. Python - one-time install
    echo    https://www.python.org/downloads/
    echo    Check Add Python to PATH when installing
    echo.
    echo See SETUP_INSTRUCTIONS.txt for details
    echo.
    pause
    exit /b 1
)

pause