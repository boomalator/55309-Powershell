#requires -version 7.0

return "This is a snippets file"
$IsWindows ? "ok":"not ok"

#maybe this is more complicated
if ($IsWindows) {
    "ok"
}
else {
    "not ok"
}
if ($IsWindows) {
    Get-CimInstance -ClassName win32_service -filter "name='bits'"
    Get-CimInstance -ClassName win32_service -filter "name='wsearch'"
}
else {
    Clear-Host
    Get-Date
    Write-Warning "This command requires Windows"
}

#compared to
$IsWindows ? (Get-CimInstance -ClassName win32_service -filter "name='bits'"),
(Get-CimInstance -ClassName win32_service -filter "name='wsearch'") : 
(Clear-Host),(Get-Date),(Write-Warning "This command requires Windows")

#variation
$win = {
 Get-CimInstance -ClassName win32_service -filter "name='bits'"
 Get-CimInstance -ClassName win32_service -filter "name='wsearch'"
}
$nowin = {
 Clear-Host
 Get-Date
 Write-Warning "This command requires Windows"
}

$IsWindows ? (&$win) : (&$nowin)


$var = (get-date).DayOfWeek -eq "Friday" ? "tgif": "blah" 