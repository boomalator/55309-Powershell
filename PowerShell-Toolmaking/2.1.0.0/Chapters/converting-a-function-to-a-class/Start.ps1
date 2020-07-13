Function Get-MachineInfo {

[CmdletBinding()]
Param(
    [Parameter(ValueFromPipeline,
        Mandatory)]
    [Alias('CN', 'MachineName', 'Name')]
    [string[]]$ComputerName
)

BEGIN {}

PROCESS {
    foreach ($computer in $computername) {
        Try {
            Write-Verbose "Connecting to $computer"
            $params = @{
                ComputerName  = $Computer
                ErrorAction   = 'Stop'
            }

            $session = New-CimSession @params

            Write-Verbose "Querying $computer"
            #define a hashtable of parameters to splat
            #to Get-CimInstance
            $cimparams = @{
                ClassName  = 'Win32_OperatingSystem'
                CimSession = $session
                ErrorAction = 'stop'
            }
            $os = Get-CimInstance @cimparams

            $cimparams.Classname = 'Win32_ComputerSystem'
            $cs = Get-CimInstance @cimparams

            $cimparams.ClassName  = 'Win32_Processor'  
            $proc = Get-CimInstance @cimparams | Select-Object -first 1

            $sysdrive = $os.SystemDrive
            $cimparams.Classname = 'Win32_LogicalDisk'
            $cimparams.Filter = "DeviceId='$sysdrive'"        
            $drive = Get-CimInstance @cimparams
                            
            Write-Verbose "Outputting for $($session.computername)"
            $obj = [pscustomobject]@{
                ComputerName      = $session.computername.ToUpper()
                OSVersion         = $os.version
                OSBuild           = $os.buildnumber
                Manufacturer      = $cs.manufacturer
                Model             = $cs.model
                Processors        = $cs.numberofprocessors
                Cores             = $cs.numberoflogicalprocessors
                RAM               = $cs.totalphysicalmemory
                Architecture      = $proc.addresswidth
                SystemFreeSpace   = $drive.freespace
            }
            Write-Output $obj

            Write-Verbose "Closing session to $computer"
            $session | Remove-CimSession
        }
        Catch {
            Write-Warning "FAILED to query $computer. $($_.exception.message)"
        }
    } #foreach
        
} #PROCESS

END {}

} #end function

Get-MachineInfo -ComputerName $env:COMPUTERNAME