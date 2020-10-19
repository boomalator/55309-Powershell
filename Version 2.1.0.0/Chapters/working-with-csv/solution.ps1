<#
Export a group of files from a directory of your choice to a CSV file selecting these properties:

* name
* extension
* fullname (exported as Path)
* length (exported as Size)
* CreationDate (exported as Created)
* LastWriteTime (exported as Modified)

Write a PowerShell expression to export the files to a CSV file. 
Create a file that you could use outside of PowerShell. 
Then write code to import the CSV file and sort by length in descending order. 
The timestamp properties should also be treated as [datetime] values.
#>

Get-ChildItem c:\work -file | 
Select-Object Name,Extension,
@{Name="Path";Expression = {$_.fullname}},
@{Name="Size";Expression = {$_.length}},
@{Name="Created";Expression = {$_.Creationtime}},
@{Name="Modified";Expression = {$_.LastWriteTime}} | 
Export-CSV -Path .\files.csv -NoTypeInformation

Function New-FileData {
[cmdletbinding()]
Param(
[Parameter(Mandatory,ValueFromPipeline)]
[object[]]$InputObject
)

Begin {}
Process {
    [PSCustomObject]@{
        PSTypeName = "FileData"
        Name = $_.Name
        Extension = $_.Extension
        Path = $_.Path
        Size = $_.Size -as [int]
        CreationTime = $_.Created -as [datetime]
        LastWritetime = $_.Modified -as [datetime]
    }
}
End {}
}

$filedata = Import-CSV .\files.csv | New-FileData

$fileData | Sort-Object size -Descending |
Select-Object Name,Size

$filedata | Get-Member