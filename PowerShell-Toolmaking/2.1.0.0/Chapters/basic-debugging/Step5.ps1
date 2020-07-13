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

            ForEach ($drive in $drives) {
                if ($drive.DriveType -ne 5) {
                    [pscustomobject]@{
                        ComputerName = $comp
                        Letter       = $drive.deviceid
                        Size         = $drive.size
                        Free         = $drive.freespace
                    }
                }
            } #foreach drive
        } #foreach computer
    } #process
} #function

Set-PSBreakpoint -Line 24 -Script ($MyInvocation.MyCommand.Source)
"localhost", "localhost" | Get-DriveInfo