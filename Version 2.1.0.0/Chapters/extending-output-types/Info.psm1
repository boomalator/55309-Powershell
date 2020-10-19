Function Get-TMComputerStatus {
 
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline, Mandatory)]
    [ValidateNotNullorEmpty()]
    [Alias("CN", "Machine", "Name")]
    [string[]]$Computername,
    [string]$ErrorLog,
    [switch]$ErrorAppend
)

BEGIN {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}

PROCESS {
  foreach ($computer in $Computername) {
     Write-Verbose "Querying $($computer.toUpper())"

     Try {
         $params = @{
          Classname    = "Win32_OperatingSystem"
          Computername = $computer
          ErrorAction  = "Stop"
        }
        $OS = Get-CimInstance @params

        $params.ClassName = "Win32_Processor"
        $cpu = Get-CimInstance @params

        $params.className = "Win32_logicalDisk"
        $vol = Get-CimInstance @params -filter "DeviceID='c:'"
        
        $OK = $True
     }
     Catch {
         $OK = $False
         $msg = "Failed to get system information from $computer. $($_.Exception.Message)"
         Write-Warning $msg
         if ($ErrorLog) {
             Write-Verbose "Logging errors to $ErrorLog. Append = $ErrorAppend"
            "[$(Get-Date)] $msg" | Out-File -FilePath $ErrorLog -Append:$ErrorAppend
         }
     }
     if ($OK) {
        #only continue if successful
        $obj = [pscustomobject]@{
          Computername = $os.CSName
          TotalMem     = $os.TotalVisibleMemorySize
          FreeMem      = $os.FreePhysicalMemory
          Processes    = $os.NumberOfProcesses
          PctFreeMem   = ($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100
          Uptime       = (Get-Date) - $os.lastBootUpTime
          CPULoad      = $cpu.LoadPercentage
          PctFreeC     = ($vol.FreeSpace/$vol.size)*100
        }

        $obj.psobject.TypeNames.Insert(0, "TMComputerStatus")

        #add a property set
        $obj | Add-Member -MemberType PropertySet -Name Mem -Value 'Computername','TotalMem','FreeMem','PctFreeMem'
       
        $obj
     } #if OK
    } #foreach $computer
}
END {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}
} #Get-TMComputerStatus


$myType = "TMComputerStatus"

Update-TypeData -TypeName $myType -DefaultDisplayPropertySet  'ComputerName','Uptime','PctFreeMem','PctFreeC'
Update-TypeData -TypeName $myType -MemberType AliasProperty -MemberName Memory -Value TotalMem -force

<#
This should work but there appears to be a bug with Update-TypeData
Update-TypeData -TypeName $myType -MemberType PropertySet -MemberName OS -Value 'Computername','OSVersion','OSBuild','Arch' -force
#>

Update-TypeData -TypeName $myType -MemberType ScriptMethod -MemberName Ping -Value { Test-NetConnection $this.computername } -force
Update-TypeData -TypeName $myType -MemberType ScriptProperty -MemberName TopProcesses -Value {
    Get-Process -ComputerName $this.computername |
    Sort-Object -Property WorkingSet -Descending |
    Select-Object -first 5
} -force

Export-ModuleMember -function Get-TMComputerStatus