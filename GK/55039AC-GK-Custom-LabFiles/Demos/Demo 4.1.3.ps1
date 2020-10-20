
Get-WmiObject -Class Win32_BIOS -ComputerName Alpha,NoName,Bravo -EA Stop -EV x
$x

<#

Note that the last error will also be in $error[0], which is a different kind of
object

#>

$x | Get-Member
$error[0] | Get-Member

