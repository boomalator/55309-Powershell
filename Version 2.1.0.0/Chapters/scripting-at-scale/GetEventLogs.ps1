#Requires -version 5.0

[cmdletbinding()]
Param(
    [Parameter(Position = 0, Mandatory)]
    [ValidateNotNullorEmpty()]
    [string[]]$Computername,

    [ValidateSet("Error", "Warning", "Information", "SuccessAudit",
    "FailureAudit")]
    [string[]]$EntryType = @("Error", "Warning"),

    [ValidateSet("System", "Application", "Security",
        "Active Directory Web Services", "DNS Server")]
    [string]$Logname = "System",

    [datetime]$After = (Get-Date).AddHours(-24),

    [Alias("path")]
    [ValidateScript({Test-Path $_})]
    [string]$OutputPath = "."
)

#define a hashtable of parameters for Write-Progress

$progParam = @{
 Activity         = $MyInvocation.MyCommand
 Status           = "Gathering $($EntryType -join ",") entries from $logname after $after."
 CurrentOperation = $null
}

Write-Progress @progParam

#invoke the command remotely as a job
$jobs = @()
foreach ($computer in $computername) {
    $progParam.CurrentOperation = "Querying: $computer"
    Write-Progress @progParam
    $jobs += Invoke-Command {
      $logParams = @{
       LogName = $using:logname
       After = $using:after
       EntryType = $using:entrytype
      }
        Get-EventLog @logParams
    } -ComputerName $Computer -AsJob
} #foreach

do {
    $count = ($jobs | Get-Job | Where-Object state -eq 'Running').count
    $progParam.CurrentOperation = "Waiting for $count remote commands to complete"
    Write-Progress @progParam
} while ($count -gt 0)

$progParam.CurrentOperation = "Receiving job results"
Write-Progress @progParam
$data = $jobs | Receive-Job

if ($data) {
    $progParam.CurrentOperation = "Creating HTML report"
    Write-Progress @progparam

    #create html report
    $fragments = @()
    $fragments += "<H1>Summary from $After</H1>"
    $fragments += "<H2>Count by server</H2>"
    $fragments += $data | Group-Object -Property Machinename |
    Sort-Object -property Count -Descending |
    Select-Object -property Count, Name |
    ConvertTo-Html -As table -Fragment

    $fragments += "<H2>Count by source</H2>"
    $fragments += $data | Group-Object -Property source |
    Sort-Object Count -Descending |
    Select-Object -property Count, Name |
    ConvertTo-Html -As table -Fragment

    $fragments += "<H2>Detail</H2>"
    $fragments += $data |
    Select-Object -property Machinename, TimeGenerated, Source, EntryType,
    Message | ConvertTo-Html -as Table -Fragment

    # the here string needs to be left justified
    $head = @"
<Title>Event Log Summary</Title>
<style>
h2 {
width:95%;
background-color:#7BA7C7;
font-family:Tahoma;
font-size:10pt;
font-color:Black;
}
body { background-color:#FFFFFF;
       font-family:Tahoma;
       font-size:10pt; }
td, th { border:1px solid black;
         border-collapse:collapse; }
th { color:white;
     background-color:black; }
table, tr, td, th { padding: 2px; margin: 0px }
tr:nth-child(odd) {background-color: lightgray}
table { width:95%;margin-left:5px; margin-bottom:20px;}
</style>
"@
    $convert = @{
     Body = $fragments
     PostContent = "<h6>$(Get-Date)</h6>"
     Head = $head
    }
    $html = ConvertTo-Html @convert

    #save results to a file
    $file = "$(Get-Date -UFormat '%Y%m%d_%H%M')_EventlogReport.htm"
    $filename = Join-Path -Path $OutputPath -ChildPath $file

    $progparam.CurrentOperation = "Saving file to $filename"
    Write-Progress @progParam
    Start-Sleep -Seconds 1

    Set-Content -Path $filename -Value $html -Encoding Ascii
    #write the result file to the pipeline
    Get-Item -Path $filename

} #if data
else {
    Write-Host "No matching event entries found." -ForegroundColor Magenta
}

#clean up jobs if any
if ($jobs) {
    $jobs | Remove-Job
}