Write-Host "Running Basic Security Check..."

# 1. Check for unusual startup programs
Write-Host "`nStartup Programs:"
Get-CimInstance -ClassName Win32_StartupCommand | Select-Object Name, Command, Location

# 2. List active network connections
Write-Host "`nActive Network Connections:"
netstat -ano | Select-String "ESTABLISHED"

# 3. Look for unknown processes (highlight unsigned)
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

# 4. Check if Windows Defender is enabled
Write-Host "`nWindows Defender Status:"
Get-MpComputerStatus | Select-Object AMServiceEnabled, AntivirusEnabled, RealTimeProtectionEnabled

# 5. Check for recent failed login attempts (last 5)
Write-Host "`nRecent Failed Login Attempts:"
Get-EventLog -LogName Security -InstanceId 4625 -Newest 5 | Format-Table TimeGenerated, Message -Wrap

# 6. Check if any remote desktop sessions are active
Write-Host "`nActive Remote Desktop Sessions:" 
query session

Write-Host "`nScan complete. Review above output for anything suspicious."
