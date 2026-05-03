param(
    [string]$Path = 'c:\Users\phoen\OneDrive\Documents\Company Website\techveons (4).html'
)
if (-not (Test-Path $Path)) {
    Write-Error "File not found: $Path"
    exit 1
}
$bak = $Path + '.bak'
Copy-Item -Path $Path -Destination $bak -Force
$bytes = [System.IO.File]::ReadAllBytes($Path)
$enc = [System.Text.Encoding]::GetEncoding(1252)
$str = $enc.GetString($bytes)
# Replace control characters except tab (9), LF (10), CR (13)
$str = [regex]::Replace($str, '[\x00-\x08\x0B\x0C\x0E-\x1F]', ' ')
[System.IO.File]::WriteAllText($Path, $str, [System.Text.Encoding]::UTF8)
Write-Host "Converted $Path to UTF-8; backup at $bak"