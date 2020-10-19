Function Get-TMRemoteListeningConfiguration {

[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline, Mandatory)]
    [ValidateNotNullorEmpty()]
    [Alias("CN")]
    [string[]]$Computername,
    [string]$ErrorLog
)

Begin {
    Write-Information "Command = $($myinvocation.mycommand)" -Tags Meta
    Write-Information "PSVersion = $($PSVersionTable.PSVersion)" -Tags Meta
    Write-Information "User = $env:userdomain\$env:username" -tags Meta
    Write-Information "Computer = $env:computername" -tags Meta
    Write-Information "PSHost = $($host.name)" -Tags Meta
    Write-Information "Test Date = $(Get-Date)" -tags Meta

    #define a private function to write the verbose messages
    Function WV {
        Param($prefix, $message)
        $time = Get-Date -f HH:mm:ss.ffff
        Write-Verbose "$time [$($prefix.padright(7,' '))] $message"
    }

    WV -prefix BEGIN -message "Starting $($myinvocation.MyCommand)"

    if ($errorlog) {
        WV BEGIN "Errors will be logged to $ErrorLog" 
        $outParams = @{
            FilePath    = $ErrorLog 
            Encoding    = "ascii"
            Append      = $True
            ErrorAction = "stop"
        }
    }
    #define a ordered hashtable of ports so that the testing
    #goes in the same order
    $ports = [ordered]@{
        WSManHTTP  = 5985
        WSManHTTPS = 5986
        SSH        = 22
    }

    #initialize an splatting hashtable
    $testParams = @{
        Port            = ""
        Computername    = ""
        WarningAction   = "SilentlyContinue"
        #changed variable to not be confusing with helper function
        WarningVariable = "warn"
    }
    #keep track of total computers tested
    $total = 0
    #keep track of how long testing takes
    $begin = Get-Date
} #begin
Process {
    foreach ($computer in $computername) {
        #assume the computer can be reached
        $ok = $True
        $total++
        #make the computername all upper case
        $testParams.Computername = $computer.ToUpper()

        WV PROCESS "Testing $($testParams.Computername)"

        #define the hashtable of properties for the custom object
        $props = [ordered]@{
            Computername = $testparams.Computername
            Date         = Get-Date
        }

        #this array will be used to store passed ports
        #It is used by Write-Information
        $passed = @() 

        #enumerate the hashtable
        foreach ($item in $ports.GetEnumerator()) {

            $testParams.Port = $item.Value
    
            WV "PROCESS" "Testing port $($testparams.port)"
            $test = Test-NetConnection @testParams

            if ($warn -match "Name resolution of $($testParams.computername) failed") {
                $msg = "[$(Get-Date)] $warn"
                if ($ErrorLog) {
                    Try {          
                        $msg | Out-File @outParams
                    }
                    Catch {
                        Write-Warning "Failed to log error. $($_.exception.message)"
                    }
                } #if errorlog
                $ok = $False
                #break out of the ForEach loop
                break
            }
        
            WV PROCESS "Adding results"
            $props.Add($item.name, $test.TCPTestSucceeded)
            if ($test.TCPTestSucceeded) {
                $passed += $testParams.Port
            }

            if (-NOT $props.Contains("RemoteAddress")) {
                wv "PROCESS" "Adding RemoteAddress $($test.remoteAddress)"
                $props.Add("RemoteAddress", $test.RemoteAddress)
            }
        
        } #foreach port

        if ($ok) {
            WV PROCESS "Generating an object for $($testparams.computername)"
            Write-Information "$($testParams.Computername) = $($passed -join ',')" -Tags data
      
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    } #foreach computer
    
} #process
End {
    $runtime = New-TimeSpan -Start $begin -End (Get-Date)
    WV END "Processed $total computer(s) in $runtime"

    #display a warning if errors would captured
    if (Test-Path -Path $ErrorLog) {
        Write-Warning "Errors were detected. See $ErrorLog."
    }

    WV END "Ending $($myinvocation.mycommand)"
} #end

} #Get-TMRemoteListeningConfiguration

Function Get-TMTrustedHosts {
    [cmdletbinding(DefaultParameterSetName="computer")]
    Param(
    [Parameter(Position = 0, Mandatory,ParameterSetName="computer")]
    [ValidateNotNullorEmpty()]
    [string[]]$ComputerName,
    [Parameter(ParameterSetName="session")]
    [System.Management.Automation.Runspaces.PSSession[]]$PSSession
    )
    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    } #begin
    Process {
        #under development    
    } #process
    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}