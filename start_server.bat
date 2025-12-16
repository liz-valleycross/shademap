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

    REM Create a temporary PowerShell script for the HTTP server
    echo $http = [System.Net.HttpListener]::new() > "%TEMP%\simple_server.ps1"
    echo $http.Prefixes.Add('http://localhost:8000/') >> "%TEMP%\simple_server.ps1"
    echo $http.Start() >> "%TEMP%\simple_server.ps1"
    echo Write-Host 'Server running at http://localhost:8000/' >> "%TEMP%\simple_server.ps1"
    echo Write-Host 'Press Ctrl+C to stop' >> "%TEMP%\simple_server.ps1"
    echo Write-Host '' >> "%TEMP%\simple_server.ps1"
    echo $root = $PWD.Path >> "%TEMP%\simple_server.ps1"
    echo while ($http.IsListening) { >> "%TEMP%\simple_server.ps1"
    echo     $context = $http.GetContext() >> "%TEMP%\simple_server.ps1"
    echo     $request = $context.Request >> "%TEMP%\simple_server.ps1"
    echo     $response = $context.Response >> "%TEMP%\simple_server.ps1"
    echo     $url = $request.Url.LocalPath >> "%TEMP%\simple_server.ps1"
    echo     if ($url -eq '/') { $url = '/sun_exposure_map.html' } >> "%TEMP%\simple_server.ps1"
    echo     $file = Join-Path $root $url.TrimStart('/') >> "%TEMP%\simple_server.ps1"
    echo     Write-Host "Request: $url" >> "%TEMP%\simple_server.ps1"
    echo     if (Test-Path $file -PathType Leaf) { >> "%TEMP%\simple_server.ps1"
    echo         $ext = [System.IO.Path]::GetExtension($file).ToLower() >> "%TEMP%\simple_server.ps1"
    echo         $mime = @{'.html'='text/html';'.css'='text/css';'.js'='application/javascript';'.csv'='text/csv';'.json'='application/json';'.png'='image/png';'.jpg'='image/jpeg';'.gif'='image/gif'}[$ext] >> "%TEMP%\simple_server.ps1"
    echo         if (-not $mime) { $mime = 'application/octet-stream' } >> "%TEMP%\simple_server.ps1"
    echo         $response.ContentType = $mime >> "%TEMP%\simple_server.ps1"
    echo         $content = [System.IO.File]::ReadAllBytes($file) >> "%TEMP%\simple_server.ps1"
    echo         $response.ContentLength64 = $content.Length >> "%TEMP%\simple_server.ps1"
    echo         $response.OutputStream.Write($content, 0, $content.Length) >> "%TEMP%\simple_server.ps1"
    echo     } else { >> "%TEMP%\simple_server.ps1"
    echo         $response.StatusCode = 404 >> "%TEMP%\simple_server.ps1"
    echo         $msg = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found') >> "%TEMP%\simple_server.ps1"
    echo         $response.OutputStream.Write($msg, 0, $msg.Length) >> "%TEMP%\simple_server.ps1"
    echo     } >> "%TEMP%\simple_server.ps1"
    echo     $response.Close() >> "%TEMP%\simple_server.ps1"
    echo } >> "%TEMP%\simple_server.ps1"

    echo Starting PowerShell HTTP server...
    start "Solar Analyzer Server" powershell -ExecutionPolicy Bypass -File "%TEMP%\simple_server.ps1"

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