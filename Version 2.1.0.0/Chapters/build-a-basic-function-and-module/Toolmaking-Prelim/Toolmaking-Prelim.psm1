Function Get-TMComputerStatus {
  Param(
    [string[]]$Computername,
    [string]$ErrorLogFilePath,
    [switch]$ErrorAppend
  )

  foreach ($computer in $Computername) {
    $OS = Get-CimInstance win32_operatingsystem -computername $computer |
    Select-Object -property CSName,TotalVisibleMemorySize,FreePhysicalMemory,NumberOfProcesses,
    @{Name="PctFreeMemory";Expression = { ($_.freephysicalmemory/($_.TotalVisibleMemorySize))*100}},
    @{Name="Uptime";Expression = { (Get-Date) - $_.lastBootUpTime}}

    $cpu = Get-CimInstance win32_processor -ComputerName $computer |
    Select-Object -Property LoadPercentage

    $vol = Get-Volume -CimSession $computer -DriveLetter C |
    Select-Object -property @{Name = "PctFreeC";Expression = {($_.SizeRemaining/$_.size)*100 }}
 
    $os,$load,$vol
  } #foreach $computer

} #Get-TMComputerStatus