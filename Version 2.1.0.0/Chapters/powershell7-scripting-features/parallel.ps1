#requires -version 7.0

return "This is a snippet file"

Help ForEach-Object -Parameter Parallel

Measure-Command {1..1000 | ForEach-Object {$_*10}}

Measure-Command { 1..1000 | ForEach-Object -parallel { $_*10}}

$locations = "\\ds416\backup","c:\work","c:\scripts","d:\temp","$home\Documents","c:\program files\windowspowershell\modules"

measure-command {
$r = $locations | ForEach-Object {
 $p = $_
 Write-Host "[$(Get-Date -f 'hh:mm:ss.ffff')] Measuring $p" -ForegroundColor green
 Get-ChildItem -Path $p -file -Recurse | 
 Measure-Object -Property length -sum -Average |
 Select-object @{Name="Path";Expression = {$p}},Count,
 @{Name="SumKB";Expression={$_.sum/1KB -as [int]}},
 @{Name="AvgKB";Expression={$_.average/1KB -as [int]}}
}
}

measure-command {
$r = $locations | ForEach-Object -parallel {
 $p = $_
 Write-Host "[$(Get-Date -f 'hh:mm:ss.ffff')] Measuring $p" -ForegroundColor green
 Get-ChildItem -Path $p -file -Recurse | 
 Measure-Object -Property length -sum -Average |
 Select-object @{Name="Path";Expression = {$p}},Count,
 @{Name="SumKB";Expression={$_.sum/1KB -as [int]}},
 @{Name="AvgKB";Expression={$_.average/1KB -as [int]}}
}
}