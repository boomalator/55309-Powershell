$Button2_Click = {
	Write-Host "Hello"
}
$Button1_Click = {
	Write-Host "GoodBye"
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'junk.designer.ps1')
$Form1.ShowDialog()