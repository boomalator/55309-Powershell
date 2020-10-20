#Requires –version 3.0
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)][string]$UserName
)
Write-Verbose "Provisioning user $UserName"

Write-Verbose "--Active Directory account"
New-ADUser –Name $UserName –samAccountName $UserName

Write-Verbose "--Home folder"
MkDir \\FSERVER\D$\UserHomes\$UserName

# NO need to run this - the point it to demonstrate
# how a controller script can accept input, but
# it mainly uses it to run other commands