Function Get-TMComputerStatus {
    [cmdletbinding()]
    Param(
    [Parameter(ValueFromPipeline=$True,Mandatory=$True)]
    [ValidateNotNullorEmpty()]
    [ValidatePattern("^\w+$")]
    [Alias("CN","Machine","Name")]
    [string[]]$Computername,
    [string]$ErrorLogFilePath,
    [switch]$ErrorAppend
    )
 
    BEGIN {}

    PROCESS {
        foreach ($computer in $Computername) {
            $params = @{
                Classname = "Win32_OperatingSystem"
                Computername = $computer
            }
            $OS = Get-CimInstance @params |
            Select-Object -property CSName,TotalVisibleMemorySize,FreePhysicalMemory,
            NumberOfProcesses,@{Name="PctFreeMemory";
            Expression = {($_.freephysicalmemory/($_.TotalVisibleMemorySize))*100}},
            @{Name="Uptime";Expression = { (Get-Date) - $_.lastBootUpTime}}

            $params.ClassName = "Win32_Processor"
            $cpu = Get-CimInstance @params | Select-Object -Property LoadPercentage

            $params.className = "Win32_logicalDisk"
            $vol = Get-CimInstance @params -filter "DeviceID='c:'" |
            Select-Object -property @{Name = "PctFreeC";Expression = `
            {($_.freespace/$_.size)*100 }}
 
                #TODO: Clean up output
                $os,$cpu,$vol

         } #foreach $computer
    }
    END {}
} #Get-TMComputerStatus
