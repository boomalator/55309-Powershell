Return "This is a snippets file not a script to run."

# simply notice the use of Write- commands in the below...
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

BEGIN {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}

PROCESS {
    foreach ($computer in $Computername) {
     Write-Verbose "Querying $computer"
     $params = @{
        Classname    = "Win32_OperatingSystem"
        Computername = $computer
     }
            
     $OS = Get-CimInstance @params

     $params.ClassName = "Win32_Processor"
     $cpu = Get-CimInstance @params

     $params.className = "Win32_logicalDisk"
     $vol = Get-CimInstance @params -filter "DeviceID='c:'"

     [pscustomobject]@{
        Computername = $os.CSName
        TotalMem     = $os.TotalVisibleMemorySize
        FreeMem      = $os.FreePhysicalMemory
        Processes    = $os.NumberOfProcesses
        PctFreeMem   = ($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100
        Uptime       = (Get-Date) - $os.lastBootUpTime
        CPULoad      = $cpu.LoadPercentage
        PctFreeC     = ($vol.FreeSpace/$vol.size)*100
     }
    } #foreach $computer
}
END {
        Write-Verbose "Ending $($myinvocation.mycommand)"
}
} #Get-TMComputerStatus

# this is what a warning looks like...
Write-Warning "Danger, Will Robinson!"

# set $VerbosePreference="Continue" for the below to work.
Write-Verbose "Execution Metadata:"
Write-Verbose "User = $($env:userdomain)\$($env:USERNAME)"
$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$IsAdmin = [System.Security.Principal.WindowsPrincipal]::new($id).IsInRole('administrators')
Write-Verbose "Is Admin = $IsAdmin"
Write-Verbose "Computername = $env:COMPUTERNAME"
Write-Verbose "OS = $((Get-CimInstance Win32_Operatingsystem).Caption)"
Write-Verbose "Host = $($host.Name)"
Write-Verbose "PSVersion = $($PSVersionTable.PSVersion)"
Write-Verbose "Runtime = $(Get-Date)"


# this example adds a prefix so you can tell which block you're in
Function Get-Foo {
    [cmdletbinding()]
    Param(
        [string]$Computername
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        Write-Verbose "[BEGIN  ] Initializing array"
        $a = @()

    } #begin

    Process {
        Write-Verbose "[PROCESS] Processing: $Computername"
        # code goes here
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #end Get-Foo


# this variation includes time stamps
Function Get-Bar {
    [cmdletbinding()]
    Param(
        [string]$Computername
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Initializing array"
        $a = @()

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing: $Computername"
        # code goes here
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending: $($MyInvocation.Mycommand)"

    } #end

} #end Get-Bar


# quick example of informational output
Function Get-Example {

    [CmdletBinding()]
    Param()

    Write-Information "First message" -tag status
    Write-Information "Note that this had no parameters" -tag notice
    Write-Information "Second message" -tag status

}

Get-Example -InformationAction Continue -InformationVariable x


# capturing informational output to a variable
function Get-Example {
    [CmdletBinding()]
    Param()

    Write-Information "First message" -tag status
    Write-Information "Note that this had no parameters" -tag notice
    Write-Information "Second message" -tag status
}

Example -InformationAction SilentlyContinue -IV x
$x

# filtering informational output
function Get-Example {
    [CmdletBinding()]
    Param()
    Write-Information "First message" -tag status
    Write-Information "Note that this had no parameters" -tag notice
    Write-Information "Second message" -tag status

}

Get-Example -InformationAction SilentlyContinue -IV x

$x | Where-Object tags -in @('notice')


# detailed informational example
Function Test-Me {
    [cmdletbinding()]
    Param()

    Write-Information "Starting $($MyInvocation.MyCommand) " -Tags Process
    Write-Information "PSVersion = $($PSVersionTable.PSVersion)" -Tags Meta
    Write-Information "OS = $((Get-CimInstance Win32_operatingsystem).`
    Caption)" -Tags Meta

    Write-Verbose "Getting top 5 processes by WorkingSet"

    Get-Process | Sort-Object WS -Descending | 
    Select-Object -first 5 -OutVariable s

    Write-Information ($s[0] | Out-String) -Tags Data

    Write-Information "Ending $($MyInvocation.MyCommand) " -Tags Process

}
test-me -InformationAction Continue
test-me -InformationVariable inf
$inf
$inf | Get-Member
$inf.where( {$_.tags -contains 'meta'}) | Select-Object Computer, MessageData


# see it with write-host
Function Test-Me2 {
    [cmdletbinding()]
    Param()

    Write-Host "Starting $($MyInvocation.MyCommand) " -fore green
    Write-Host "PSVersion = $($PSVersionTable.PSVersion)" -fore green
    Write-Host "OS = $((Get-CimInstance Win32_operatingsystem).Caption)" -fore green

    Write-Verbose "Getting top 5 processes by WorkingSet"
    Get-Process | Sort-Object WS -Descending | Select-Object -first 5 -OutVariable s

    Write-Host ($s[0] | Out-String) -fore green

    Write-Host "Ending $($MyInvocation.MyCommand) " -fore green

}







