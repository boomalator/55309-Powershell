Return "This is a snippets file not a script to run."

# example - this will not execute
Get-Content computernames.txt | Test-PCConnection | Get-Whatever

# examples - will not execute
Get-Content names.txt | Set-MachineStatus
Get-ADComputer -filter * | Select -Expand Name | Set-MachineStatus
Get-ADComputer -filter * | Set-MachineStatus
Set-MachineStatus -ComputerName (Get-Content names.txt)

# design - these will not execute
Get-RemoteListeningConfiguration -Computername SRV1
Get-RemoteListeningConfiguration -Computername SRV1,SRV2
Get-Content servers.txt | Get-RemoteListeningConfiguration
Import-CSV servers.csv | Get-RemoteListeningConfiguration
Get-RemoteListeningConfiguration (Get-ADComputer -filter *).Name

# example - will not execute
Get-Content servers.txt | Get-RemoteListeningConfiguration -LogPath errorlog.txt

