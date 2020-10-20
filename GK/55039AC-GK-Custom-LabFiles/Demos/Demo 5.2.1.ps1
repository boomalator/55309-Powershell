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
                    $os = Get-WmiObject -class Win32_OperatingSystem `
                                        -computerName $computer `
                                        -erroraction Stop
                    Write-Output $os
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