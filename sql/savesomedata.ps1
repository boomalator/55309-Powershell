#requires -module MyTools

$connParams = 
@{
    'Database' = 'AdventureWorks'
    'ServerInstance' = 'bphdemos.database.windows.net'
    'Username' = $userStr
    'Password' = $passwdStr
    'OutputSqlErrors' = $true
}

Function saveSQLRow {
param(
    [string]$ComputerName,
    [string]$model,
    [string]$manufacturer,
    [string]$osVersion,
    [string]$spversion)

$InsertCmd = 
@"
    INSERT INTO [dbo].[Computers](ComputerName, Model, Manufacturer,osVersion,spVersion)
    VALUES ('$ComputerName','$model','$manufacturer','$osVersion','$spVersion')
"@
    
    Invoke-sqlcmd @connparams -Query $InsertCmd
}

Invoke-sqlcmd @connparams -Query "DELETE FROM [dbo].[Computers]"

$myComputers = Get-ComputerNamesFromXML -Filename C:\Scripts\computers.xml | Get-OSInfo 

ForEach ($pc in $myComputers)
{
    $name = $pc | Select -ExpandProperty Computername
    $man = $pc | Select -ExpandProperty manufacturer
    $model = $pc | Select -ExpandProperty model
    $os | Select -ExpandProperty osversion
    $sp | Select -ExpandProperty spversion
    Write-Host "Working on Computer... $name"
    SaveSQLRow -ComputerName $name -model $model -manufacturer $man -osVersion $os -spversion $sp
    Write-Host "Processed $name"
}
