#Requires -version 5.0

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

    #Methods
    [void]Refresh() {

        Try {
            $params = @{
                ComputerName = $this.Computername
                ErrorAction  = 'Stop'
            }
            $session = New-CimSession @params

            $os_params = @{
                ClassName  = 'Win32_OperatingSystem'
                CimSession = $session
            }
            $os = Get-CimInstance @os_params

            $cs_params = @{
                ClassName  = 'Win32_ComputerSystem'
                CimSession = $session
            }
            $cs = Get-CimInstance @cs_params

            $sysdrive = $os.SystemDrive
            $drive_params = @{
                ClassName  = 'Win32_LogicalDisk'
                Filter     = "DeviceId='$sysdrive'"
                CimSession = $session
            }
            $drive = Get-CimInstance @drive_params

            $proc_params = @{
                ClassName  = 'Win32_Processor'
                CimSession = $session
            }
            $proc = Get-CimInstance @proc_params |
            Select-Object -first 1

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
        } #try
        Catch {
            throw "Failed to connect to $this.computername. $($_.Exception.message)"
        } #catch
    }

    # Constructors
    TMMachineInfo([string]$ComputerName) {
        $this.ComputerName = $ComputerName
        $this.Refresh()
    }
} #class

Function Get-MachineInfo {
    [cmdletbinding()]
    [alias("gmi")]
    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [Alias("cn")]
        [ValidateNotNullorEmpty()]
        [string[]]$Computername = $env:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin

    Process {
        foreach ($computer in $computername) {
            Write-Verbose "[PROCESS] Getting machine information from $($computer.toUpper())"
            New-Object -TypeName TMMachineInfo -ArgumentList $computer
        }
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}

Function Update-MachineInfo {
    [cmdletbinding()]
    [alias("umi")]
    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [ValidateNotNullorEmpty()]
        [TMMachineInfo]$Info,
        [switch]$Passthru
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin

    Process {
        Write-Verbose "[PROCESS] Refreshing: $(($Info.ComputerName).ToUpper())"
        $info.Refresh()

        if ($Passthru) {
            #write the updated object back to the pipeline
            $info
        }
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}
Function Show-MachineInfo {
    [cmdletbinding()]
    [alias("smi")]

    Param(
        [Parameter(Position = 0)]
        [Alias("cn")]
        [ValidateNotNullorEmpty()]
        [string]$Computername = $env:COMPUTERNAME
    )

    $form = New-Object System.Windows.Window
    $form.Title = "TMMachine Info"
    $form.Width = 300
    $form.Height = 350

    $stack = New-Object System.Windows.Controls.StackPanel

    $txtInput = New-Object System.Windows.Controls.TextBox
    $txtInput.Width = 100
    $txtInput.HorizontalAlignment = "left"
    $txtInput.Text = $Computername

    $stack.AddChild($txtInput)

    $txtResults = New-Object System.Windows.Controls.TextBlock
    $txtResults.FontFamily = "Consolas"
    $txtResults.HorizontalAlignment = "left"

    $txtResults.Height = 200

    $stack.AddChild($txtResults)

    $btnRun = New-Object System.Windows.Controls.Button
    $btnRun.Content = "_Run"
    $btnRun.Width = 60
    $btnRun.HorizontalAlignment = "Center"

    $OK = {
        #get machine info from the name in the text box.
        #we're trimming the value in case there are extra spaces
        $data = Get-MachineInfo -Computername ($txtInput.text).trim()

        #set the value of the txtResults to the data as a string
        $txtResults.text = $data | Out-String
    }

    $btnRun.Add_click($OK)

    $stack.AddChild($btnRun)

    $btnQuit = New-Object System.Windows.Controls.Button
    $btnQuit.Content = "_Quit"
    $btnQuit.Width = 60
    $btnQuit.HorizontalAlignment = "center"

    $btnQuit.Add_click({$form.close()})

    $stack.AddChild($btnQuit)
    $form.AddChild($stack)
    $form.add_Loaded($ok)

    [void]($form.ShowDialog())
}
