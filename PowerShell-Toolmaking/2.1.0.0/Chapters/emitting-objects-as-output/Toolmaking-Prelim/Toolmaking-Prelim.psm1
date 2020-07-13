Function Get-TMComputerStatus {
    [cmdletbinding()]
    Param(
        [Parameter(ValueFromPipeline = $True, Mandatory = $True)]
        [ValidateNotNullorEmpty()]
        [ValidatePattern("^\w+$")]
        [Alias("CN", "Machine", "Name")]
        [string[]]$Computername,
        [string]$ErrorLogFilePath,
        [switch]$ErrorAppend
    )

    BEGIN {}

    PROCESS {
        foreach ($computer in $Computername) {
            $params = @{
                Classname    = "Win32_OperatingSystem"
                Computername = $computer
            }
            $OS = Get-CimInstance @params

            $params.ClassName = "Win32_Processor"
            $cpu = Get-CimInstance @params

            $params.className = "Win32_logicalDisk"
            $vol = Get-CimInstance @params -filter "DeviceID='c:'"

            $props = @{
                Computername = $os.CSName
                TotalMem     = $os.TotalVisibleMemorySize
                FreeMem      = $os.FreePhysicalMemory
                Processes    = $os.NumberOfProcesses
                PctFreeMem   = ($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100
                Uptime       = (Get-Date) - $os.lastBootUpTime
                CPULoad      = $cpu.LoadPercentage
                PctFreeC     = ($vol.FreeSpace/$vol.size)*100
            }
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj

        } #foreach $computer
    }
    END {}
} #Get-TMComputerStatus

