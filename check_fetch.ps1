$wc = New-Object System.Net.WebClient
$wc.Encoding = [System.Text.Encoding]::UTF8
$s = $wc.DownloadString('http://127.0.0.1:8000/techveons%20(4).html')
$pos14 = $s.IndexOf([char]0x14)
$posFFFD = $s.IndexOf([char]0xFFFD)
Write-Host "pos14=$pos14 posFFFD=$posFFFD"
if ($pos14 -ge 0) {
    Write-Host "Context (pos14):"
    $start=[Math]::Max(0,$pos14-20)
    $len=[Math]::Min(80, $s.Length-$start)
    Write-Host $s.Substring($start,$len)
}
if ($posFFFD -ge 0) {
    Write-Host "Context (FFFD):"
    $start=[Math]::Max(0,$posFFFD-20)
    $len=[Math]::Min(80, $s.Length-$start)
    Write-Host $s.Substring($start,$len)
}