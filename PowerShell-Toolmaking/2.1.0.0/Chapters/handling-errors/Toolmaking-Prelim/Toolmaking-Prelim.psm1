Function Get-TMComputerStatus {
 <#
.SYNOPSIS
Get computer status information.

.DESCRIPTION
This command retrieves system information from one or more remote computers
using Get-CimInstance. It will write a summary object to the pipeline for
each computer. You also have the option to log errors to a text file.

.PARAMETER Computername
The name of the computer to query. Tou must have admin rights to remotely
connect to the comptuer. This parameter has aliases of CN, Machine and Name.

.PARAMETER CimSession
An existing CIMSession object.

.PARAMETER ErrorLog
The path to the error text file. This is not implemented yet.

.PARAMETER ErrorAppend
Append errors to the error file. This is not implemented yet.

.EXAMPLE
PS C:\> Get-TMComputerStatus -computername SRV1

Computername : SRV1
TotalMem     : 33080040
FreeMem      : 27384236
Processes    : 218
PctFreeMem   : 82.7817499616083
Uptime       : 11.06:23:52.7176115
CPULoad      : 2
PctFreeC     : 54.8730920184876

Get the status of a single computer

.EXAMPLE
PS C:\> Get-Content c:\work\computers.txt | Get-TMComputerStatus |
Export-CliXML c:\work\data.xml

Pipe each computer name from the computers.txt text file to this
command. Results are immediately exported to an XML file using
Export-CliXML.

.EXAMPLE
PS C:\> Get-CimSession | Get-TMComputerstatus | Out-Gridview

Get status information using an existing set of CIMSessions.
.INPUTS
System.String

.NOTES
Version     : 2.0.0

.LINK
Get-CimInstance
#>
[cmdletbinding(DefaultParameterSetName = "computer")]
Param(
    [Parameter(
        Position = 0,
        ValueFromPipeline,
        Mandatory,
        ParameterSetName = "computer"
    )]
    [ValidateNotNullorEmpty()]
    [Alias("CN", "Machine", "Name")]
    [string[]]$Computername,
    [Parameter(
        ParameterSetName = "session",
        ValueFromPipeline
    )]
    [ValidateNotNullorEmpty()]
    [Microsoft.Management.Infrastructure.CimSession[]]$CimSession,
    [string]$ErrorLog,
    [switch]$ErrorAppend
)

BEGIN {
    Write-Information "Command = $($myinvocation.mycommand)" -Tags Meta
    Write-Information "PSVersion = $($PSVersionTable.PSVersion)" -Tags Meta
    Write-Information "User = $env:userdomain\$env:username" -tags Meta
    Write-Information "Computer = $env:computername" -tags Meta
    Write-Information "PSHost = $($host.name)" -Tags Meta
    Write-Information "Test Date = $(Get-Date)" -tags Meta
    Write-Verbose "Starting $($myinvocation.mycommand)"

    $tmpSession = @()
}

PROCESS {

    if ($PSCmdlet.ParameterSetName -eq "computer") {
        foreach ($computer in $Computername) {
            Try {
                Write-Verbose "Creating temporary CIMSession to $computer"
                $tmpSession += New-CimSession -ComputerName $computer -ErrorAction stop
            } #try
            Catch {
                $msg = "Failed to connect to $computer. $($_.Exception.Message)"
                Write-Warning $msg
                if ($ErrorLog) {
                    Write-Verbose "Logging errors to $ErrorLog. Append = $ErrorAppend"
                    "[$(Get-Date)] $msg" | Out-File -FilePath $ErrorLog -Append:$ErrorAppend
                }
            } #catch
        } #foreach computer

        #copy the temp sessions to the CimSessions parameter
        $CimSessions = $tmpSession
    } # computer parameter set

    #use CIMSessions for everything
    foreach ($session in $CimSession) {
        Write-Verbose "Querying $($session.computername)"

        Try {
            $params = @{
                Classname   = "Win32_OperatingSystem"
                CimSession  = $session
                ErrorAction = "Stop"
            }
            $OS = Get-CimInstance @params

            $params.ClassName = "Win32_Processor"
            $cpu = Get-CimInstance @params

            $params.className = "Win32_logicalDisk"
            $vol = Get-CimInstance @params -filter "DeviceID='c:'"

            $OK = $True
        }
        Catch {
            #this should probably never happen
            $OK = $False
            $msg = "Failed to get system information from $($session.computername). $($_.Exception.Message)"
            Write-Warning $msg
            if ($ErrorLog) {
                Write-Verbose "Logging errors to $ErrorLog. Append = $ErrorAppend"
                "[$(Get-Date)] $msg" | Out-File -FilePath $ErrorLog -Append:$ErrorAppend
            }
        }
        if ($OK) {
            #only continue if successful
            [pscustomobject]@{
                Computername = $os.CSName
                TotalMem     = $os.TotalVisibleMemorySize
                FreeMem      = $os.FreePhysicalMemory
                Processes    = $os.NumberOfProcesses
                PctFreeMem   = ($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100
                Uptime       = (Get-Date) - $os.lastBootUpTime
                CPULoad      = $cpu.LoadPercentage
                PctFreeC     = ($vol.FreeSpace/$vol.size)*100
            }
        } #if OK
    } #foreach $computer
}
END {
    #remove temporary sessions
    $tmpSession | Remove-CimSession
    Write-Verbose "Ending $($myinvocation.mycommand)"
}
} #Get-TMComputerStatus
