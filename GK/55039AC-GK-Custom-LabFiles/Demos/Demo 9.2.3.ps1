<#
.SYNOPSIS
Retrieves key system version and model information
from one to ten computers.
.DESCRIPTION
Get-OSInfo uses Windows Management Instrumentation
(WMI) to retrieve information from one or more computers.
Specify computers by name or by IP address.
.PARAMETER ComputerName
One or more computer names or IP addresses.
.PARAMETER LogErrors
Specify this switch to create a text log file of computers
that could not be queried.
.PARAMETER ErrorLog
When used with -LogErrors, specifies the file path and name
to which failed computer names will be written. Defaults to
C:\Scripts\Retry.txt.
.EXAMPLE
 Get-Content names.txt | Get-OSInfo
.EXAMPLE
 Get-OSInfo -ComputerName SERVER1,SERVER2
#>
function Get-OSInfo {
[CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\Scripts\retry.txt',

        [switch]$LogErrors
    )
    BEGIN {
        Remove-Item $ErrorLog -ErrorAction SilentlyContinue
    }
    PROCESS {
        foreach ($computer in $computername) {       
                Try {

                    Write-Verbose "Connecting to $computer"
                    $gwmi = @{
                       'Class'='Win32_OperatingSystem';
                       'ComputerName'=$computer;
                       'ErrorAction'='Stop'}
                    $os = Get-WmiObject @gwmi

                    $gwmi = @{
                       'Class'='Win32_ComputerSystem';
                       'ComputerName'=$computer;
                       'ErrorAction'='Stop'}
                    $cs = Get-WmiObject @gwmi

                    $props = @{
                       'ComputerName'=$computer;
                       'OSVersion'=$os.version;
                       'SPVersion'=$os.servicepackmajorversion;
                       'OSBuild'=$os.buildnumber;
                       'Manufacturer'=$cs.manufacturer;
                       'Model'=$cs.model}

                    $obj = New-Object –TypeName PSObject –Property $props
                    $obj.psobject.typenames.insert(0,'MOL.SystemInfo');
                    Write-Output $obj
                } Catch {
                    Write-Verbose "$computer failed"
                    if ($LogErrors) {
                        $computer | Out-File $ErrorLog -Append
                    }
                    Write-Warning "Error contacting $computer"
                }
        }
    }
    END {}
}
