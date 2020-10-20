function Get-OSInfo {
[CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\Scripts\retry.txt',

        [switch]$LogErrors
    )
    BEGIN {
        Remove-Item $ErrorLog –ErrorAction SilentlyContinue
    }
    PROCESS {
        foreach ($computer in $computername) {       
                Try {

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
                       'Mfgr'=$cs.manufacturer;
                       'Model'=$cs.model}

                    $obj = New-Object –TypeName PSObject –Property $props
                    
                    Write-Output $obj
                } Catch {
                    if ($LogErrors) {
                        $computer | Out-File $ErrorLog -Append
                    }
                    Write-Warning "Error contacting $computer"
                }
        }
    }
    END {}
}

'Alpha','Bravo' | Get-OSInfo
# Get-OSInfo -computername Alpha,Bravo