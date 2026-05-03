$path = 'c:\Users\phoen\OneDrive\Documents\Company Website\techveons (4).html'
$bytes = [System.IO.File]::ReadAllBytes($path)
$len = [Math]::Min(64, $bytes.Length)
$hex = ($bytes[0..($len-1)] | ForEach-Object { '{0:X2}' -f $_ }) -join ' '
Write-Host $hex