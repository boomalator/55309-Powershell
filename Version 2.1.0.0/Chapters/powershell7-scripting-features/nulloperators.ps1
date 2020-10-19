#requires -version 7.0

return "This is a snippets file"

#null coalescing

$foo = $null
$foo ?? "bar"

$foo = $PSVersionTable.PSVersion.ToString()
$foo ?? "bar"

$c = $SomeVariable
$computername = $c ?? ([system.environment]::MachineName)

$computername ??= ([system.environment]::MachineName)


$p = Get-Process -id $pid
${p}?.startTime

$n = 2,4,6,8,10
${n}?[2]

help about_operators