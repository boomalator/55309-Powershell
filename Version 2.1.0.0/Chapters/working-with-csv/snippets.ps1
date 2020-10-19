return "This is a snippets file"

#this is wrong
Get-Service win* | Export-CSV win.csv
Import-CSV win.csv

#know your data
Get-Service win* -ComputerName SRV1 | 
Select-Object -property Name,Displayname,Status,Starttype,
@{Name="Computername";Expression={$_.machinename}} | 
Export-CSV win-srv1.csv

#suppress type info
... | Export-CSV file.csv -NoTypeInformation

#using custom headers
$head = "Computername","Type","AssetTag","Acquired"
Import-Csv .\data-nohead.csv -Header $head

help get-Service -Parameter computername

Import-Csv .\data.csv | 
Select-Object @{Name="computername";Expression={$_.server}} | 
Get-Service Bits | Select-Object Machinename,Name,Status

#use the custom header
Get-Content .\data.csv | Select-Object -Skip 1 | 
ConvertFrom-CSV -Header $head | 
Get-Service Bits | 
Select-Object Machinename,Name,Status

#not as expected
Import-Csv .\data.csv | Sort-Object Inventory

Import-Csv .\data.csv | 
Select-Object @{Name="ComputerName";Expression={$_.server}},
Asset,Class,
@{Name="InventoryDate";Expression = {$_.Inventory -as [datetime]}} |
Sort-Object InventoryDate

#we could have done this
Import-Csv .\data.csv | Sort-Object {$_.Inventory -as [datetime]}