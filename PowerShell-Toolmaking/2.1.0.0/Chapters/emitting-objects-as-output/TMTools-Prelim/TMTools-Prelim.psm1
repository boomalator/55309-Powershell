Function Get-TMRemoteListeningConfiguration {
  [cmdletbinding()]
  Param(
    [Parameter(ValueFromPipeline = $True, Mandatory = $True)]
    [ValidateNotNullorEmpty()]
    [Alias("CN")]
    [string[]]$Computername,
    [string]$ErrorLog
  )

  Begin {
    #define a hashtable of ports
    $ports = @{
      WSManHTTP  = 5985
      WSManHTTPS = 5986
      SSH        = 22
    }

    #initialize an splatting hashtable
    $testParams = @{
      Port         = ""
      Computername = ""
    }
  } #begin
  Process {

    foreach ($computer in $computername) {
      $testParams.Computername = $computer

      #define the hashtable of properties for
      #the custom object
      $props = @{
        Computername = $computer
        Date         = Get-Date
      }

      #enumerate the hashtable
      $ports.GetEnumerator() | ForEach-Object {
        $testParams.Port = $_.Value
        $test = Test-NetConnection @testParams

        #add results
        $props.Add($_.name, $test.TCPTestSucceeded)

        #assume the same remote address will respond to all
        #requests
        if (-NOT $props.ContainsKey("RemoteAddress")) {
          $props.Add("RemoteAddress", $test.RemoteAddress)
        }
      }

      #create the custom object
      $obj = New-Object -TypeName PSObject -Property $props
      Write-Output $obj

      #TODO
      #error handling and logging
    } #foreach
  } #process
  End {
    #not used
  } #end
} #Get-RemoteListeningConfiguration function