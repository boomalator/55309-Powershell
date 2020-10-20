# Continue - the default
$ErrorActionPreference = 'Continue'
Get-WmiObject -Class Win32_BIOS -ComputerName Alpha,NoName,Bravo

# SilentlyContinue
$ErrorActionPreference = 'SilentlyContinue'
Get-WmiObject -Class Win32_BIOS -ComputerName Alpha,NoName,Bravo

# Inquire
$ErrorActionPreference = 'Inquire'
Get-WmiObject -Class Win32_BIOS -ComputerName Alpha,NoName,Bravo

# Stop - note that it never tries DC
$ErrorActionPreference = 'Stop'
Get-WmiObject -Class Win32_BIOS -ComputerName Alpha,NoName,Bravo
