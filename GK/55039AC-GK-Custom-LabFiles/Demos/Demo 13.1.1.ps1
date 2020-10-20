# Copy Demo 13.1.1.xml to C:\Scripts\computers.xml.

[xml]$xml = Get-Content C:\Scripts\computers.xml
$xml

$xml.computers

$xml.computers.computer[0]