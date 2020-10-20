[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,
               ValueFromPipeline=$True,
               ValueFromPipelineByPropertyName=$True)]
    [string[]]$ComputerName,

    [Parameter(Mandatory=$True)]
    [string]$Path
)
PROCESS {

function Get-InfoOS {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string]$ComputerName
    )
    $os = Get-WmiObject -class Win32_OperatingSystem -ComputerName $ComputerName
    $props = @{'OSVersion'=$os.version;
               'SPVersion'=$os.servicepackmajorversion;
               'OSBuild'=$os.buildnumber}
    New-Object -TypeName PSObject -Property $props
}

function Get-InfoCompSystem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string]$ComputerName
    )
    $cs = Get-WmiObject -class Win32_ComputerSystem -ComputerName $ComputerName
    $props = @{'Model'=$cs.model;
               'Manufacturer'=$cs.manufacturer;
               'RAM (GB)'="{0:N2}" -f ($cs.totalphysicalmemory / 1GB);
               'Sockets'=$cs.numberofprocessors;
               'Cores'=$cs.numberoflogicalprocessors}
    New-Object -TypeName PSObject -Property $props
}

function Get-InfoBadService {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string]$ComputerName
    )
    $svcs = Get-WmiObject -class Win32_Service -ComputerName $ComputerName `
           -Filter "StartMode='Auto' AND State<>'Running'"
    foreach ($svc in $svcs) {
        $props = @{'ServiceName'=$svc.name;
                   'LogonAccount'=$svc.startname;
                   'DisplayName'=$svc.displayname}
        New-Object -TypeName PSObject -Property $props
    }
}

function Get-InfoProc {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string]$ComputerName
    )
    $procs = Get-WmiObject -class Win32_Process -ComputerName $ComputerName
    foreach ($proc in $procs) { 
        $props = @{'ProcName'=$proc.name;
                   'Executable'=$proc.ExecutablePath}
        New-Object -TypeName PSObject -Property $props
    }
}

function Get-InfoNIC {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string]$ComputerName
    )
    $nics = Get-WmiObject -class Win32_NetworkAdapter -Computer $ComputerName `
           -Filter "PhysicalAdapter=True"
    foreach ($nic in $nics) {      
        $props = @{'NICName'=$nic.servicename;
                   'Speed'=$nic.speed / 1MB -as [int];
                   'Manufacturer'=$nic.manufacturer;
                   'MACAddress'=$nic.macaddress}
        New-Object -TypeName PSObject -Property $props
    }
}

foreach ($computer in $computername) {
    try {
        $everything_ok = $true
        Write-Verbose "Checking connectivity to $computer"
        Get-WmiObject -class Win32_BIOS -ComputerName $Computer -EA Stop | 
        Out-Null
    } catch {
        Write-Warning "$computer failed"
        $everything_ok = $false
    }

    if ($everything_ok) {
     if ($everything_ok) {
        $filepath = Join-Path -Path $Path -ChildPath "$computer.html"
        $html_os = Get-InfoOS -ComputerName $computer |
                   ConvertTo-HTML -As List -Fragment -PreContent "<h2>OS</h2>" |
                   Out-String
        $html_cs = Get-InfoCompSystem -ComputerName $computer |
                   ConvertTo-HTML -As List -Fragment -PreContent "<h2>Hardware</h2>" |
                   Out-String
        $html_pr = Get-InfoProc -ComputerName $computer |
                   ConvertTo-HTML -Fragment -PreContent "<h2>Processes</h2>" |
                   Out-String
        $html_sv = Get-InfoBadService -ComputerName $computer |
                   ConvertTo-HTML -Fragment -PreContent "<h2>Check Services</h2>" |
                   Out-String
        $html_na = Get-InfoNIC -ComputerName $Computer |
                   ConvertTo-HTML -Fragment -PreContent "<h2>NICs</h2>" |
                   Out-String

        $params = @{'Title'="Report for $computer";
                    'PreContent'="<h1>System Report for $computer</h1>";
                    'PostContent'=$html_os,$html_cs,$html_pr,$html_sv,$html_na}
        ConvertTo-HTML @params | Out-File -FilePath $filepath 
    } 
  }
}

}

# Run this script from the console with:
# -ComputerName Alpha,Bravo -path c:\Scripts\reports\