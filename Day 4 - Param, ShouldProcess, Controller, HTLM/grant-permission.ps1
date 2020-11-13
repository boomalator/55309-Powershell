$defaultValue = $MbxStr
if (($MbxStr = Read-Host "Which Shared Mailbox [$defaultValue]") -eq '') {$MbxStr = $defaultValue} 

$defaultValue = $UserStr
if (($UserStr = Read-Host "Which User should get permission [$defaultValue]") -eq '') {$UserStr = $defaultValue} 

Write-Host "Mailbox: $MbxStr"
Write-Host "Delegate: $UserStr"