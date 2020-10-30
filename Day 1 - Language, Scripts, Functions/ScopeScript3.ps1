Write-Host "Var1 is $var1"

$script:var1 = "This is a Script Var"
Write-Host "Var1 is $var1"

Write-Host "Global: $global:var1; Script: $script:var1"