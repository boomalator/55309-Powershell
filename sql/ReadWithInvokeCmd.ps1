# The simplest way to connect directly from Powershell
#

$connParams = 
@{
    'Database' = 'AdventureWorks'
    'ServerInstance' = 'bphdemos.database.windows.net'
    'Username' = $userStr
    'Password' = $passwdStr
    'OutputSqlErrors' = $true
    'Query' = 'SELECT TOP 20 * From  [SalesLT].[Customer] ORDER BY LASTNAME DESC'
}

# Invoke-Sqlcmd @connParams 

$data2 = Invoke-Sqlcmd @connParams
$data2 | ConvertTo-Html | Out-File -FilePath 'c:\sql\basic-report.html'





