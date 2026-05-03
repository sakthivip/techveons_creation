$port = 8000
$root = 'C:\Users\phoen\OneDrive\Documents\Company Website'
$prefix = "http://127.0.0.1:$port/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Serving $root on $prefix"
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    Write-Host "Request: $($request.HttpMethod) $($request.Url.PathAndQuery)"
    $relPath = [System.Uri]::UnescapeDataString($request.Url.AbsolutePath).TrimStart('/')
    if ($relPath -eq '') { $relPath = 'index.html' }
    $target = Join-Path $root $relPath
    if (Test-Path $target -PathType Container) { $target = Join-Path $target 'index.html' }
    if (Test-Path $target -PathType Leaf) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($target)
            $ext = [System.IO.Path]::GetExtension($target).ToLowerInvariant()
            switch ($ext) {
                '.html' { $ctype='text/html; charset=utf-8' }
                '.htm' { $ctype='text/html; charset=utf-8' }
                '.css' { $ctype='text/css; charset=utf-8' }
                '.js' { $ctype='application/javascript; charset=utf-8' }
                '.json' { $ctype='application/json; charset=utf-8' }
                '.png' { $ctype='image/png' }
                '.jpg' { $ctype='image/jpeg' }
                '.jpeg' { $ctype='image/jpeg' }
                '.gif' { $ctype='image/gif' }
                '.svg' { $ctype='image/svg+xml' }
                '.txt' { $ctype='text/plain; charset=utf-8' }
                default { $ctype='application/octet-stream' }
            }
            $context.Response.ContentType = $ctype
            if ($ctype -match '^(text/|application/(javascript|json))') {
                if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
                    $outBytes = $bytes
                } elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
                    $str = [System.Text.Encoding]::Unicode.GetString($bytes, 2, $bytes.Length - 2)
                    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($str)
                } elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
                    $str = [System.Text.Encoding]::BigEndianUnicode.GetString($bytes, 2, $bytes.Length - 2)
                    $outBytes = [System.Text.Encoding]::UTF8.GetBytes($str)
                } else {
                    try {
                        $str = [System.Text.Encoding]::UTF8.GetString($bytes)
                        $outBytes = [System.Text.Encoding]::UTF8.GetBytes($str)
                    } catch {
                        $str = [System.Text.Encoding]::Default.GetString($bytes)
                        $outBytes = [System.Text.Encoding]::UTF8.GetBytes($str)
                    }
                }
            } else {
                $outBytes = $bytes
            }
            $context.Response.ContentLength64 = $outBytes.Length
            $context.Response.OutputStream.Write($outBytes,0,$outBytes.Length)
            $context.Response.OutputStream.Close()
        } catch {
            $context.Response.StatusCode = 500
            $buffer = [System.Text.Encoding]::UTF8.GetBytes('500 Internal Server Error')
            $context.Response.OutputStream.Write($buffer,0,$buffer.Length)
            $context.Response.OutputStream.Close()
        }
    } else {
        $context.Response.StatusCode = 404
        $buffer = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found')
        $context.Response.ContentType = 'text/plain'
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer,0,$buffer.Length)
        $context.Response.OutputStream.Close()
    }
}