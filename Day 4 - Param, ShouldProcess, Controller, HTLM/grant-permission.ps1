$defaultValue = $MbxStr
if (($MbxStr = Read-Host "Which Shared Mailbox [$defaultValue]") -eq '') {$MbxStr = $defaultValue} 

try 
    { 
        $Mbx = Get-Mailbox $MbxStr -ErrorAction stop
    } catch {
        Write-Host "Couldn't get mailbox for $MbxStr."
        break
    } 

$defaultValue = $UserStr
if (($UserStr = Read-Host "Which User should get permission [$defaultValue]") -eq '') {$UserStr = $defaultValue} 

Write-Host "Mailbox: $MbxStr"
Write-Host "Delegate: $UserStr"