function Get-DriveInfo {
    [CmdletBinding()]
    Param(
        [Parameter(
        Mandatory,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline)]
        [string[]]$ComputerName
    )
    PROCESS {
        Write-Debug "[PROCESS] Beginning"
        ForEach ($comp in $ComputerName) {

            Write-Debug "[PROCESS] on $comp"
            $session = New-CimSession -ComputerName $comp
            $params = @{
                CimSession = $session
                ClassName  = 'Win32_LogicalDisk'
            }
            $drives = Get-CimInstance @params

            Write-Debug "[PROCESS] CIM query complete"
            if ($drives.DriveType -notlike '*optical*') {
                [pscustomobject]@{
                    ComputerName = $comp
                    Letter       = $drives.deviceid
                    Size         = $drives.size
                    Free         = $drives.freespace
                }
            }
        } #foreach
    } #process
} #function

"localhost", "localhost" | Get-DriveInfo -Debug