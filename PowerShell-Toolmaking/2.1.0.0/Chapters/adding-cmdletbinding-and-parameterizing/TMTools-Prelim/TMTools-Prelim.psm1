Function Get-TMRemoteListeningConfiguration {
    [cmdletbinding()]
    Param(
    [Parameter(ValueFromPipeline = $True, Mandatory = $True)]
    [ValidateNotNullorEmpty()]
    [Alias("CN")]
    [string[]]$Computername,
    [string]$ErrorLog
    )

    Begin {
      #not used
    }
    Process {
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
   }
   End {
    #not used
   }
} #Get-TMRemoteListeningConfiguration function