Function Get-TMRemoteListeningConfiguration {

<#
.Synopsis
Test remote listening ports.

.Description
This command will be used to test the network listening configuration on one
or more remote computers. It will test if standard PowerShell remoting is 
enabled on both ports 5985 and 5986. It will also test if SSH is enabled on
port 22.

Because the command is testing at the network layer, you do not need to use
any credentials.

.Parameter Computername
Specify the name of IP address of a remote computer. 

.Parameter ErrorLog
Specify the path to a text file to log errors. This feature is still in
development.

.Example
PS C:\> Get-TMRemoteListeningConfiguration -Computername srv1

Computername  : SRV1
Date          : 7/28/2020 5:13:57 PM
WSManHTTP     : True
RemoteAddress : 192.168.3.50
WSManHTTPS    : False
SSH           : False

Get configuration information for a single computer.

.Example
PS C:\> Get-Content c:\work\computers.txt | Get-TMRemoteListeningConfiguration | Export-CSV c:\work\results.csv -NoTypeinformation

Get remote listening information for every computer in the computers.txt file and
export results to a CSV file.

.Inputs
System.String

.Link
Test-NetConnection

#>
  [cmdletbinding()]
  Param(
    [Parameter(ValueFromPipeline,Mandatory)]
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
    Param($prefix,$message)
        $time = Get-Date -f HH:mm:ss.ffff
        Write-Verbose "$time [$($prefix.padright(7,' '))] $message"
    }

    WV -prefix BEGIN -message "Starting $($myinvocation.MyCommand)"

    #define a ordered hashtable of ports so that the testing
    #goes in the same order
    $ports = [ordered]@{
      WSManHTTP  = 5985
      WSManHTTPS = 5986
      SSH        = 22
    }

    #initialize an splatting hashtable
    $testParams = @{
      Port         = ""
      Computername = ""
      WarningAction = "SilentlyContinue"
      WarningVariable = "wv"
    }
    #keep track of total computers tested
    $total=0
    #keep track of how long testing takes
    $begin = Get-Date
  } #begin
  Process {
    foreach ($computer in $computername) {
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
      $ports.GetEnumerator() | ForEach-Object {
        $testParams.Port = $_.Value
    
        WV "PROCESS" "Testing port $($testparams.port)"
        $test = Test-NetConnection @testParams

        WV PROCESS "Adding results"
        $props.Add($_.name, $test.TCPTestSucceeded)
        if ($test.TCPTestSucceeded) {
            $passed+=$testParams.Port
        }

        if (-NOT $props.Contains("RemoteAddress")) {
           wv "PROCESS" "Adding RemoteAddress $($test.remoteAddress)"
          $props.Add("RemoteAddress", $test.RemoteAddress)
        }
      }

      Write-Information "$($testParams.Computername) = $($passed -join ',')" `
      -Tags data

      $obj = New-Object -TypeName PSObject -Property $props
      Write-Output $obj

      #TODO: error handling and logging
    } #foreach
  } #process
  End {
    $runtime = New-TimeSpan -Start $begin -End (Get-Date)
    WV END "Processed $total computer(s) in $runtime"
    WV END "Ending $($myinvocation.mycommand)"
  } #end

} #Get-TMRemoteListeningConfiguration function