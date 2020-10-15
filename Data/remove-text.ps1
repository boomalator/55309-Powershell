$filename = '\\alpha\LabFiles\test\test1.txt'
whoami
if (Test-Path $filename) { Remove-Item $filename }
New-Item $filename
Start-Sleep -Seconds 7