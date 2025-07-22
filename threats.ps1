Write-Host "Running Basic Security Check..."

Write-Host "`nStartup Programs:"
Get-CimInstance -ClassName Win32_StartupCommand | Select-Object Name, Command, Location

Write-Host "`nActive Network Connections:"
netstat -ano | Select-String "ESTABLISHED"

Write-Host "`nRunning Processes (with Signature Info):"
Get-Process | ForEach-Object {
    $path = $_.Path
    if ($path) {
        $sig = Get-AuthenticodeSignature $path
        [PSCustomObject]@{
            Name = $_.Name
            PID = $_.Id
            Path = $path
            Signed = $sig.SignerCertificate.Subject
            Status = $sig.Status
        }
    }
} | Where-Object { $_.Status -ne "Valid" } | Format-Table -AutoSize

Write-Host "`nWindows Defender Status:"
Get-MpComputerStatus | Select-Object AMServiceEnabled, AntivirusEnabled, RealTimeProtectionEnabled

Write-Host "`nRecent Failed Login Attempts:"
Get-EventLog -LogName Security -InstanceId 4625 -Newest 5 | Format-Table TimeGenerated, Message -Wrap

Write-Host "`nActive Remote Desktop Sessions:" 
query session

Write-Host "`nScan complete. Review above output for anything suspicious."
