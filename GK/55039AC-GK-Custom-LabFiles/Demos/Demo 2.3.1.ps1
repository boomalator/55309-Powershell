function Get-DiskInfo {
    param(
        [string]$computername,
        [int]$drivetype = 3
    )

    Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=$DriveType" -ComputerName $computername
}

Get-DiskInfo -computername Alpha
