function Get-ComputerNamesFromXML {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ParameterSetName='Text')]
        [string[]]$InputText,

        [Parameter(ParameterSetName='File')]
        [string]$Filename
    )
    BEGIN {
        $content = ''
    }
    PROCESS {
        $content += $InputText
    }
    END {
        if ($PSBoundParameters.ContainsKey('InputText')) {
            [xml]$xml = $content
        } else {
            [xml]$xml = Get-Content $filename
        }
        foreach ($computer in $xml.computers.computer) {
            $prop = @{'ComputerName'=$computer.name}
            New-Object -TypeName PSObject -Property $prop
        }
    }
} 

Get-Content C:\Scripts\computers.xml | Get-ComputerNamesFromXML

<#
Get-ComputerNamesFromXML –FileName C:\Scripts\Computers.xml |
Get-OSInfo 
#>