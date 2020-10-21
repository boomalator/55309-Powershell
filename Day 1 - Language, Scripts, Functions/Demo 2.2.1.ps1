<#

This file is an example of how you might parameterize the following command:

  Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName Alpha

Note how default values are applied in this example

#>

param(
    [string]$computername,
    [int]$drivetype = 3
)

Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=$DriveType" -ComputerName $computername

