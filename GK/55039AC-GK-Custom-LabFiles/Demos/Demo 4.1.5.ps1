function Get-DiskInfo {
    param(
        [string]$computername,
        [int]$drivetype = 3
    )
    Try {
        Get-CimInstance -EA Stop -EV x -ClassName Win32_LogicalDisk -Filter "DriveType=$DriveType" -ComputerName $computername
    } Catch {
        Write-Warning "Error on $computername was $x"
    }
}

Get-DiskInfo -computername NoPC
