$metadata = New-Object System.Management.Automation.CommandMetaData (Get-Command ConvertTo-HTML)
[System.Management.Automation.ProxyCommand]::Create($metadata) | Out-File NewScript.ps1
Notepad NewScript.ps1