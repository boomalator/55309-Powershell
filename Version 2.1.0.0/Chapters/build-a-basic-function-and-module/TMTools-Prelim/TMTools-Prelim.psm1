Function Get-TMRemoteListeningConfiguration {
    Param(
    [string[]]$Computername,
    [string]$ErrorLog
    )

    $ports = 22,5985,5986
    foreach ($computer in $computername) {
        foreach ($port in $ports) {
            Test-NetConnection -Port $port -ComputerName $Computer |
            Select-Object Computername,RemotePort,TCPTestSucceeded
        }
        #TODO
        #better output
        #error handling and logging
    } #foreach

} #Get-TMRemoteListeningConfiguration function