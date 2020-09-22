function Get-OSInfo {
    param (
        [string]$computername
    )
    Get-WmiObject –Class Win32_OperatingSystem –ComputerName $computername | 
      Select-Object Version,ServicePackMajorVersion,BuildNumber,OSArchitecture | out-host
}

function Get-DiskInfo {
    param (
        [string]$computername,
        [int]$drivetype ,
        [int]$percentfree = 99
    )
    Get-WmiObject –Class Win32_LogicalDisk –Filter "DriveType=$drivetype" –Computer $computername |
      Where-Object { $_.FreeSpace / $_.Size * 100 –lt $percentfree }  | Out-Host
}

function Invoke-Restart {
    Param (
        [string]$computername,
        [int[]]$arg = @(6)
    )
    Get-WmiObject –Class Win32_OperatingSystem –ComputerName $computername |
      Invoke-WmiMethod –Name Win32Shutdown -ArgumentList $arg |
      Out-Null
}

function Invoke-OSShutdown {
    Param (
        [string]$computername,
        [int[]]$arg = @(12)
    )
    Get-WmiObject –Class Win32_OperatingSystem –ComputerName $computername |
      Invoke-WmiMethod –Name Win32Shutdown -ArgumentList $arg |
      Out-Null
}

function Invoke-OSLogoff {
    Param (
        [string]$computername,
        [int[]]$arg = @(4)
    )
    Get-WmiObject –Class Win32_OperatingSystem –ComputerName $computername |
      Invoke-WmiMethod –Name Win32Shutdown -ArgumentList $arg |
      Out-Null

<#
Problem with Invoke-WMI:

1. The argument is ARGUMENTLIST not ARG or ARGUMENT (Grrrr.)
        FIX: Use the right freaking command paramater.

2. You have to specify the value for -ArgumentList as an explicit array. 
If you look at the MSDN documentation for this method you'll discover 
other method parameter values, which you can certainly use. 
But personally many of them are duplicated with cmdlets like 
Restart-Computer and Stop-Computer; given a choice I prefer to use a cmdlet.
        FIX: Make the scalar "4" an array @(4)

3. 4 is force log off, not force shut down. 6 is restart, 12 is shutdown, power off
        FIX: Rename the function or live with it for the lab.

#>

}


Get-OSInfo –ComputerName Bravo
Get-DiskInfo –ComputerName Bravo –DriveType 3

<# Problem with display order:

Just to clarify: the problem is only a display problem:

When outputting to the console, if the first object is table-formatted 
(if Format-Table is applied, which happens implicitly in your case), 
the display columns are locked in based on that first object's properties.
Since your second output object shares no properties with the first one, 
it contributes nothing to the table display and is therefore effectively invisible.

By contrast, if you programmatically process the script's output - 
assign it to a variable or send its output through the pipeline to another command - 
both objects will be there.

Solutions:
    specify fl
    use out-host/write-host
    build a complex object (later)

#>

