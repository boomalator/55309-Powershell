Write-Host "1. Display local system information"
Write-Host "2. Restart computer"
Write-Host "3. Display recent Application event log entries"
$choice = Read-Host ">> Select option and press Enter"
switch ($choice) {
  1 { Get-WmiObject –Class Win32_OperatingSystem | Select * }
  2 { Restart-Computer }
  3 { Get-EventLog –LogName Application –Newest 100 }
}

# No intention to run this - mainly demonstration
# of how a controller script can provide a UI