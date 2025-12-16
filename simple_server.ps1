# Simple HTTP Server for Solar Trailer Analyzer
# This script requires no installation - uses built-in Windows PowerShell

$port = 8000
$root = $PSScriptRoot

Write-Host "Starting HTTP server on port $port..."
Write-Host "Serving files from: $root"
Write-Host ""

$http = [System.Net.HttpListener]::new()
$http.Prefixes.Add("http://localhost:$port/")

try {
    $http.Start()
} catch {
    Write-Host "ERROR: Could not start server on port $port" -ForegroundColor Red
    Write-Host "The port may be in use. Try closing other applications." -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "Server running at http://localhost:$port/" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop"
Write-Host ""

$mimeTypes = @{
    '.html' = 'text/html'
    '.css'  = 'text/css'
    '.js'   = 'application/javascript'
    '.csv'  = 'text/csv'
    '.json' = 'application/json'
    '.png'  = 'image/png'
    '.jpg'  = 'image/jpeg'
    '.jpeg' = 'image/jpeg'
    '.gif'  = 'image/gif'
    '.svg'  = 'image/svg+xml'
    '.ico'  = 'image/x-icon'
}

while ($http.IsListening) {
    $context = $http.GetContext()
    $request = $context.Request
    $response = $context.Response

    $url = $request.Url.LocalPath
    if ($url -eq '/') {
        $url = '/sun_exposure_map.html'
    }

    $filePath = Join-Path $root $url.TrimStart('/')

    Write-Host "$(Get-Date -Format 'HH:mm:ss') - $($request.HttpMethod) $url"

    if (Test-Path $filePath -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        $mime = $mimeTypes[$ext]
        if (-not $mime) {
            $mime = 'application/octet-stream'
        }

        $response.ContentType = $mime
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        Write-Host "  -> 404 Not Found" -ForegroundColor Yellow
        $response.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $url")
        $response.OutputStream.Write($msg, 0, $msg.Length)
    }

    $response.Close()
}
