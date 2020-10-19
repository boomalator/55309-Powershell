#requires -version 7.0

return "This is a snippets file"

# &&
#<cmd> && <run if cmd completed without error>

1 && 2


 test-wsman thinkp1 && Get-CimInstance win32_bios -ComputerName Thinkp1


# ||
# <cmd> || <run if cmd failed>

1/0 || Write-Warning "What are you trying to do?"

Get-Service foo && Write-Host "service found" || Write-Host "service failed" -ForegroundColor red

#this doesn't work the way you think
$svc = Get-Service bits && Write-Host "service $($svc.name) found" || Write-Host "service failed" -ForegroundColor red

$svc = Get-Service bits -ov s && Write-Host "service $($s.name) found" || Write-Host "service failed" -ForegroundColor red

help about_pipeline_chain_operators