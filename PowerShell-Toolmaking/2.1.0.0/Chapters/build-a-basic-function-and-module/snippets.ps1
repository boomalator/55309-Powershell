Return "This is a snippets file not a script to run."

# design input parameters
Function Get-TMComputerStatus {
 Param(
  [string[]]$Computername,
  [string]$ErrorLogFilePath,
  [switch]$ErrorAppend
 )
}


# write the code
Function Get-TMComputerStatus {
 Param(
  [string[]]$Computername,
  [string]$ErrorLogFilePath,
  [switch]$ErrorAppend
 )

  foreach ($computer in $Computername) {
    # get data via Get-CimInstance and Get-Volume
    # create output object
  } #foreach #computer

} #Get-TMComputerStatus

# foreach construct model
ForEach ($item in $collection) {
    # code
}

# variable naming for foreach
$names = Get-Content names.txt
ForEach ($name in $names) {
    # code
}

# naming is for human convenience, shell doesn't care
$names = Get-Content names.txt
ForEach ($purple in $unicorns) {
    # code
}

# design the output
Function Get-TMComputerStatus {
  Param(
    [string[]]$Computername,
    [string]$ErrorLogFilePath,
    [switch]$ErrorAppend
  )

  foreach ($computer in $Computername) {
    $OS = Get-CimInstance win32_operatingsystem -computername $computer |
    Select-Object -property CSName,TotalVisibleMemorySize,FreePhysicalMemory,
    NumberOfProcesses,
    @{Name="PctFreeMemory";Expression = {($_.freephysicalmemory/`
    ($_.TotalVisibleMemorySize))*100}},
    @{Name="Uptime";Expression = { (Get-Date) - $_.lastBootUpTime}}

    $cpu = Get-CimInstance win32_processor -ComputerName $computer |
    Select-Object -Property LoadPercentage

    $vol = Get-Volume -CimSession $computer -DriveLetter C |
    Select-Object -property @{Name = "PctFreeC";Expression = `
    {($_.SizeRemaining/$_.size)*100 }}
 
    $os,$cpu,$vol

  } #foreach $computer

} #Get-TMComputerStatus

# new module manifest - fix file path as needed
Set-Location "\Program Files\WindowsPowerShell\Modules\Toolmaking"
New-ModuleManifest -Path .\Toolmaking.psd1
                   -Author "Don Jones & Jeff Hicks"
                   -RootModule .\Toolmaking.psm1
                   -FunctionsToExport @('Get-TMComputerStatus')
                   -Description "Sample Toolmaking module"
                   -ModuleVersion 1.0.0.0



# valid paths for a module
$env:PSModulePath
