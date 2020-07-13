function Get-ServiceRemote {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName
                   )]
        [string[]]$ComputerName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Name')]
        [string[]]$ServiceName
    )

    if ($PSBoundParameters.ContainsKey('ServiceName')) {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            Get-Service -Name $using:ServiceName
        }
    } else {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            Get-Service 
        }
    }
}