$path = 'c:\Users\phoen\OneDrive\Documents\Company Website\techveons (4).html'
$bytes = [System.IO.File]::ReadAllBytes($path)
for ($i=0; $i -lt $bytes.Length; $i++) {
    $val = $bytes[$i]
    if ($val -lt 32 -and $val -ne 9 -and $val -ne 10 -and $val -ne 13) {
        Write-Host ($i.ToString() + ': ' + $val.ToString())
    }
    if ($i -gt 20000) { break }
}
Write-Host "Done"
