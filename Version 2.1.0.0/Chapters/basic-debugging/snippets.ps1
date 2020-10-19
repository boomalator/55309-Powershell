Return "This is a snippets file not a script to run."

# eco-friendly errors
$host.privatedata.errorforegroundcolor = 'green'

# code to debug
function Get-DriveInfo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )
    PROCESS {
        ForEach ($comp in $ComputerName) {

            $session = New-CimSession -ComputerName $comp
            $params = @{
                CimSession = $session
                ClassName  = 'Win32_LogicalDisk'
            }
            $drives = Get-CimInstance @params

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

