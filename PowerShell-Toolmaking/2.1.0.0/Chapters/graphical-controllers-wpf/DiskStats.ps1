#disk stat code

#start with PowerShell code that already works
$cimParams = @{
    Computername = "localhost", $env:computername
    classname    = "win32_logicaldisk"
    filter       = "drivetype=3"
}
Get-CimInstance @cimParams |
Select-Object -Property @{Name = "Computername";Expression = {$_.SystemName}},
DeviceID, @{Name = "SizeGB";Expression = {$_.Size/1GB -as [int]}},
@{Name = "FreeGB";Expression = { [math]::Round($_.Freespace/1GB, 2)}},
@{Name = "PctFree";Expression = { ($_.freespace/$_.size)*100 -as [int]}}