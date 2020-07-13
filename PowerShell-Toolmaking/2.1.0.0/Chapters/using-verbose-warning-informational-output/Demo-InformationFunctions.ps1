#requires -version 5.1

Function Test-Me {
[cmdletbinding()]
Param()

Write-Information "Starting $($MyInvocation.MyCommand) " -Tags Process
Write-Information "PSVersion = $($PSVersionTable.PSVersion)" -Tags Meta
Write-Information "OS = $((Get-CimInstance Win32_operatingsystem).Caption)" `
 -Tags Meta

Write-Verbose "Getting top 5 processes by WorkingSet"
Get-Process | Sort-Object WS -Descending |
Select-Object -first 5 -OutVariable s

Write-Information ($s[0] | Out-String) -Tags Data

Write-Information "Ending $($MyInvocation.MyCommand) " -Tags Process
}

Function Test-Me2 {
[cmdletbinding()]
Param()

Write-Host "Starting $($MyInvocation.MyCommand) " -fore green
Write-Host "PSVersion = $($PSVersionTable.PSVersion)" -fore green
Write-Host "OS = $((Get-CimInstance Win32_operatingsystem).Caption)" `
-fore green

Write-Verbose "Getting top 5 processes by WorkingSet"
Get-Process | Sort-Object -property WS -Descending |
Select-Object -first 5 -OutVariable s

Write-Host ($s[0] | Out-String) -fore green

Write-Host "Ending $($MyInvocation.MyCommand) " -fore green
}

Function Test-Me3 {
[cmdletbinding()]
Param()

if ($PSBoundParameters.ContainsKey("InformationVariable")) {
  $Info = $True
  $infVar = $PSBoundParameters["InformationVariable"]
}

if ($info) {
  Write-Host "Starting $($MyInvocation.MyCommand) " -fore green

  (Get-Variable $infVar).value[-1].Tags.Add("Process")
  Write-Host "PSVersion = $($PSVersionTable.PSVersion)" -fore green
  (Get-Variable $infVar).value[-1].Tags.Add("Meta")
  Write-Host "OS = $((Get-CimInstance Win32_operatingsystem).Caption)" `
  -fore green
  (Get-Variable $infVar).value[-1].Tags.Add("Meta")
}
Write-Verbose "Getting top 5 processes by WorkingSet"
Get-Process | Sort-Object WS -Descending | 
Select-Object -first 5 -OutVariable s

if ($info) {
  Write-Host ($s[0] | Out-String) -fore green
  (Get-Variable $infVar).value[-1].Tags.Add("Data")
  Write-Host "Ending $($MyInvocation.MyCommand) " -fore green
  (Get-Variable $infVar).value[-1].Tags.Add("Process")
  }
}