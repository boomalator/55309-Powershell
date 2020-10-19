#Invoke-Plaster -TemplatePath 'C:\Program Files\WindowsPowerShell\Modules\myTemplates\myFunction\' -DestinationPath c:\MyNewTool -name "Get-MyThing" -version "0.1.0" -Outputtype "[PSCustomObject]" -shouldprocess No -help No -computername yes

"Get-MyThing","Set-MyThing","Remove-MyThing","Invoke-Something" | foreach -begin {

$splat = @{
TemplatePath = 'C:\Program Files\WindowsPowerShell\Modules\myTemplates\myFunction\' 
DestinationPath = "c:\MyNewTool"
version = "0.1.0" 
Outputtype = "[PSCustomObject]" 
shouldprocess = "Yes" 
help = "No"
computername = "yes"
NoLogo = $True
}

} -process {
 #add the name
 $splat.name = $_
 if ($_ -match 'Get') {
    $splat.ShouldProcess = "No"
 }
 Invoke-Plaster @splat
}