return "This is a snippets file"

Function Get-Bits {
  [cmdletbinding()]
  Param([string[]]$Computername = $env:computername)

  Begin {
    $file = "{0}_{1}.txt" -f (Get-Date -f "yyyy_MMddhhmm"), 
    $($myinvocation.MyCommand)
    $tfile = Join-Path -Path $env:temp -ChildPath $file
    [void](Start-Transcript -Path $tfile)
    Write-Verbose "Starting $($myinvocation.MyCommand)"
    $PSBoundParameters | Out-String | Write-Verbose
  }
  Process {
    foreach ($computer in $Computername) {
      Write-Host "Getting BITS from $computer" -ForegroundColor green
      Get-Service -Name Bits -ComputerName $computer
    }
  }
  End {
    Write-Verbose "Ending $($myinvocation.MyCommand)"
    [void](Stop-Transcript)
  }

} #end function

Function Get-Bits {
  [cmdletbinding()]
  Param(
    [Parameter(Position = 0, ValueFromPipeline)]
    [string[]]$Computername = $env:computername
  )

  Begin {
    $start = Get-Date
    $msg = "[$start] Starting $($myinvocation.MyCommand)"
    Write-Verbose $msg
    Write-Information $msg -Tags meta,begin

    $count = 0
    $errorcount = 0
    $PSBoundParameters | Out-String | Write-Verbose

    $cim = @{
      ClassName    = 'Win32_Service'
      Filter       = "name='bits'"
      ErrorAction  = "Stop"
      Computername = ""
    }
  }
  Process {
    foreach ($computer in $Computername) {
      $count++
      $cim.Computername = $Computer
      Write-Information "Query $computer" -Tags process
      Try {
        Write-Host "Getting BITS from $computer" -ForegroundColor green
        Get-CimInstance @cim |
        Select-Object @{Name = "Computername";Expression = {$_.SystemName}},
        Name, State, StartMode
      }
      Catch {
        $errorcount++
        $msg = "Failed to query $computer. $($_.exception.message)"
        Write-Warning $msg
        Write-Information $msg -Tags process, error
      }
    }
  }
  End {
    $end = Get-Date
    $timespan = New-Timespan -start $start -end $end
    $sum = "Processed $count computer(s) with $errorcount error(s) in $timespan"
    Write-Information $sum -Tags meta,end
    $msg = "[$end] Ending $($myinvocation.MyCommand)"
    Write-Information $msg -Tags meta,end
    
    Write-Verbose $msg
  }

} #end function

$r = "thinkp1","srv1","srv3","bovine320" | 
Get-Bits -InformationVariable iv -Verbose

$iv | Select-Object -property TimeGenerated,MessageData,tags
$iv | Where-Object tags -contains meta | 
Select-Object -property TimeGenerated,User,MessageData | 
format-Table -GroupBy User -Property TimeGenerated,MessageData

#add to the End Block
$xml = "$($env:computername)-{0}_{1}.xml" -f (Get-Date -f "yyyy_MMddhhmm"),$($myinvocation.MyCommand)
$export = Join-Path -path C:\work -ChildPath $xml
$PSCmdlet.GetVariableValue($PSBoundParameters["InformationVariable"]) | Export-Clixml $export 

#set this
$PSDefaultParameterValues["Get-Bits:InformationVariable"]="myIV"