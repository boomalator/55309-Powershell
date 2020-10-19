#requires -version 5.0

Function Get-DiskUsage {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string[]]$Computername = $env:Computername)

    Begin {
        #define a hashtable of parameter values for Get-CimInstance
        $pm = @{
            Classname    = 'Win32_logicaldisk'
            Filter       = "drivetype=3"
            ComputerName = $Null
            ErrorAction  = 'stop'
        }
    } #begin

    Process {
        foreach ($computer in $Computername) {
            Try {
                #set the next computername
                $pm.Computername = $Computer
                $d = Get-CimInstance @pm
                $d | Select-Object @{Name = "Date";Expression = {(Get-Date).ToShortDateString()}},
                PSComputername, DeviceID, Size, Freespace,
                @{Name = "PercentFree";Expression = {($_.freespace/$_.size)*100 -as [int]}}
            }
            Catch {
                Write-Warning "[$computer] $($_.exception.message)"
            }
        } #foreach computer
    } #process

    End {
        #not used
    } #end
}

Function New-DiskXML {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the filename and path for the new disk XML file"
        )]
        [string]$Path
    )

    [xml]$doc = New-Object System.Xml.XmlDocument

    #create declaration
    $dec = $doc.CreateXmlDeclaration("1.0", "UTF-8", $null)

    #append to document
    $doc.AppendChild($dec) | Out-Null

    #create the outer node
    $node = $doc.CreateNode("element", "snapshots", $null)

    $doc.AppendChild($node) | Out-Null

    if ($PSCmdlet.ShouldProcess($path)) {
        $doc.Save($path)
    }
}

Function Update-DiskXML {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the filename and path for the disk XML file"
        )]
        [string]$Path,
        [Parameter(ValueFromPipeline)]
        [string[]]$Computername = $env:COMPUTERNAME
    )

    Begin {

        if (-Not (Test-Path -Path $path)) {
            #create the file if it doesn't exist
            New-DiskXML -Path $path
        }

        #resolve and convert the path to a filesystem
        $cpath = Convert-Path -Path $path

        #open the XML document
        [xml]$doc = Get-Content -Path $cpath

        #select the Snapshots node
        $snapshots = $doc.ChildNodes[1]  #or $doc.SelectSingleNode("snapshots")

        #property names
        $props = "Date", "PSComputername", "DeviceID", "Size", "Freespace",
        "PercentFree"
    } #begin
    Process {
        $data = Get-DiskUsage $Computername
        foreach ($item in $data) {
            $snap = $doc.CreateNode("element", "snapshot", $null)

            #create an entry for each
            $props | ForEach-Object {
                $e = $doc.CreateElement($_)
                $e.InnerText = $item.$_
                $snap.AppendChild($e) | Out-Null
            }
            $snapshots.AppendChild($snap) | Out-Null
        }
    } #process

    End {
        if ($PSCmdlet.ShouldProcess($cpath)) {
            $doc.save($cpath)
        }
    } #end
}
