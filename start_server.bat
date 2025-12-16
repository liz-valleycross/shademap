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
    REM Try PowerShell as fallback (built into Windows)
    echo Python not found, trying PowerShell...
    echo.

    if not exist simple_server.ps1 (
        echo ERROR: simple_server.ps1 not found!
        echo Please make sure the file exists in this folder.
        pause
        exit /b 1
    )

    echo Starting PowerShell HTTP server...
    start "Solar Analyzer Server" powershell -ExecutionPolicy Bypass -File "%~dp0simple_server.ps1"

    timeout /t 3 /nobreak >nul

    echo Opening browser...
    start http://localhost:8000/sun_exposure_map.html

    echo.
    echo ===================================
    echo Server is running on port 8000
    echo Close the PowerShell window to stop
    echo ===================================
)

pause