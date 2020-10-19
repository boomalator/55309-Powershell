class TMMachineInfo {

    # Properties
    [string]$ComputerName
    [string]$OSVersion
    [string]$OSBuild
    [string]$Manufacturer
    [string]$Model
    [string]$Processors
    [string]$Cores
    [string]$RAM
    [string]$SystemFreeSpace
    [string]$Architecture
    hidden[datetime]$Date

    # Constructors
    TMMachineInfo([string]$ComputerName) {

         Try {
            $params = @{
                ComputerName  = $Computername
                ErrorAction   = 'Stop'
            }

            $session = New-CimSession @params

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
            
            $session | Remove-CimSession
            #use the computername from the CIM instance
            $this.ComputerName = $os.CSName
            $this.OSVersion = $os.version
            $this.OSBuild = $os.buildnumber
            $this.Manufacturer = $cs.manufacturer
            $this.Model = $cs.model
            $this.Processors = $cs.numberofprocessors
            $this.Cores = $cs.numberoflogicalprocessors
            $this.RAM = ($cs.totalphysicalmemory / 1GB)
            $this.Architecture = $proc.addresswidth
            $this.SystemFreeSpace = $drive.freespace
            $this.date = Get-Date
        }
        Catch {
            throw "Failed to connect to $computername. $($_.exception.message)"
        } #try/catch
    }
} #class

New-Object -TypeName TMMachineInfo -ArgumentList "localhost"