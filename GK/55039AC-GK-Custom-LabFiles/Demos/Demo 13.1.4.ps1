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

function Set-OSVersionInXML {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True)]
        [object]$SystemInfoObject,

        [Parameter(Mandatory=$True)]
        [string]$InputXMLFile,

        [Parameter(Mandatory=$True)]
        [string]$OutputXMLFile,

        [switch]$PassThru
    )
    PROCESS {
        foreach ($obj in $SystemInfoObject) {
            # get input XML
            [xml]$xml = Get-Content $InputXMLFile

            # find this computer's node
            $computer  = $xml.SelectSingleNode(
                         "//computer[@name='$($obj.computername)']")

            # add the info
            $computer.osversion = $obj.osversion

            # write original input object to pipeline
            if ($PassThru) {
                Write-Output $obj
            }
        }
    }
    end {
        # save modified XML
        $xml.Save($OutputXMLFile)
    }
} 

function Set-InfoInXML {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True)]
        [object]$SystemInfoObject,

        [Parameter(Mandatory=$True)]
        [string]$InputXMLFile,

        [Parameter(Mandatory=$True)]
        [string]$OutputXMLFile,

        [switch]$PassThru
    )
    Begin {
        # get input XML
        [xml]$xml = Get-Content $InputXMLFile
    }
    PROCESS {
        foreach ($obj in $SystemInfoObject) {
            # find this computer's node
            $computer = $xml.SelectSingleNode("//computer[@name='$($obj.computername)']")

            # add the OS version info
            $computer.osversion = $obj.osversion

            # create new node for manufacturer
            $mfgr_node = $xml.CreateNode('element','manufacturer','')
            $mfgr_node.InnerText = $obj.manufacturer 

            # create new attribute for manufacturer
            $mfgr_attr = $xml.CreateAttribute('manufacturer')
            $mfgr_attr.Value = $obj.manufacturer

            # add the nodes
            $computer.AppendChild($mfgr_node) | Out-Null
            $computer.SetAttributeNode($mfgr_attr) | Out-Null

            # write original input object to pipeline
            if ($PassThru) {
                Write-Output $obj
            }
        }
    }
    end {
        # save modified XML
        $xml.Save($OutputXMLFile)
    }
    
}

# Assumes you have the MyTools module
# from Chapter 11 installed in the 
# C:\Program Files\WindowsPowerShell\Modules\MyTools folder.

Get-ComputerNamesFromXML -Filename C:\Scripts\computers.xml |
Get-OSInfo |
Set-InfoInXML -input C:\Scripts\computers.xml -output C:\Scripts\computers2.xml 



