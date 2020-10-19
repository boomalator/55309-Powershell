return "This is a snippets file"

Function New-SysInfo {
    [cmdletbinding()]
    Param([string[]]$Computername = $env:Computername)

    $cim = @{
        Classname    = ""
        Computername = ""
        ErrorAction  = "Stop"
    }
    foreach ($computer in $computername) {
        $cim.Computername = $Computer
        Try {
            $cim.classname = "Win32_OperatingSystem"
            $os = Get-CimInstance @Cim
            $cim.classname = "Win32_Process"
            $ps = Get-CimInstance @cim
            
            [PSCustomobject]@{
                Computername = $os.CSName
                Processes    = $PS.Count
                OS           = $os.Caption
                Build        = $os.BuildNumber
                BootTime     = $os.LastBootUpTime
            }
        }
        Catch {
            Write-Warning "Failed to get information from $($Computer.ToUpper())"
            Write-Warning $($_.exception.message)
        }
    } #foreach
} #New-SysInfo


#revised with type
Function New-SysInfo {
    [cmdletbinding()]
    Param([string[]]$Computername = $env:Computername)

    $cim = @{
        Classname    = ""
        Computername = ""
        ErrorAction  = "Stop"
    }
    foreach ($computer in $computername) {
        $cim.Computername = $Computer
        Try {
            $cim.classname = "Win32_OperatingSystem"
            $os = Get-CimInstance @Cim
            $cim.classname = "Win32_Process"
            $ps = Get-CimInstance @cim
            
            [PSCustomobject]@{
                PSTypename   = 'SysInfo'
                Computername = $os.CSName
                Processes    = $PS.Count
                OS           = $os.Caption
                Build        = $os.BuildNumber
                BootTime     = $os.LastBootUpTime
            }
        }
        Catch {
            Write-Warning "Failed to get information from $($Computer.ToUpper())"
            Write-Warning $($_.exception.message)
        }
    } #foreach
} #New-SysInfo

Update-FormatData .\sysinfo.format.ps1xml

# Install-Module PSScriptTools
$new = @{
    Path       = '.\sysinfo.format.ps1xml'
    Properties = 'Processes', 'OS', 'BootTime'
    GroupBy    = 'Computername'
    ViewName   = 'computer'
    FormatType = 'table'
    Append     = $True
}
New-SysInfo | New-PSFormatXML @new

New-SysInfo 

New-Sysinfo | Format-Table -View computer

Import-Module .\TMMachineInfo\TMMachineInfo.psd1 -force

$new = @{
    Path       = 'TMMachineInfo\tmmachineinfo.format.ps1xml'
    Properties = 'Computername', 'OSVersion', 'Manufacturer','RAM'
    ViewName   = 'default'
    FormatType = 'table'
}
Get-Machineinfo | New-PSFormatXML @new

$new = @{
    Path       = 'TMMachineInfo\tmmachineinfo.format.ps1xml'
    Properties = 'Computername','Manufacturer','Model','Processors','Cores','RAM','SystemFreeSpace'
    ViewName   = 'hardware'
    FormatType = 'table'
    Append     = $True
}
Get-Machineinfo | New-PSFormatXML @new

Import-Module .\TMMachineInfo\TMMachineInfo.psd1 -force
Get-MachineInfo
Get-MachineInfo thinkp1, bovine320,srv1 | Format-Table -view hardware