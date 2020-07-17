function Get-Disk {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string[]]$ComputerName
    )
    foreach ($comp in $computername) {
        $logfile = "errors.txt"
        Write-Verbose "Trying $comp"
        try {
            Get-CimInstance -ClassName win32_logicaldisk -ComputerName $comp -ea stop
        } catch {
            $comp | Out-File $logfile -Append
        }
    }
}