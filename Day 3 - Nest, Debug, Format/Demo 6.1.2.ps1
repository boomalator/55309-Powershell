function Get-DetailedSystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string[]]$computerName
    )
    PROCESS {
        foreach ($computer in $computerName) {
            $params = @{computerName=$computer;           
                        class='Win32_OperatingSystem'}    
            $os = Get-WmiObject @params                   

            $params = @{computerName=$computer;           
                        class='Win32_LogicalDisk';        
                        filter='drivetype=3'}             
            $disks = Get-WmiObject @params                
            
            $diskobjs = @() 
                                          
            foreach ($disk in $disks) { 
                $diskprops = @{Drive=$disk.DeviceID;      
                               Size=$disk.size;         
                               Free=$disk.freespace}    
                $diskobj = new-object -Type PSObject -Property $diskprops
                $diskobjs += $diskobj                     
            }

            $mainprops = @{ComputerName=$computer;        
                           Disks=$diskobjs;
                           OSVersion=$os.version;
                           SPVersion=$os.servicepackmajorversion}
            $mainobject = New-Object -Type PSObject -Property $mainprops
            Write-Output $mainobject
        }
    }
}

Get-DetailedSystemInfo -computerName Alpha,Bravo | Get-Member
