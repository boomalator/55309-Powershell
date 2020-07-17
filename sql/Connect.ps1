# Connection String
# Azure will show you the connection string,
# or search for "connection string builder"

$userStr = "bphynes"
$passwdStr = "DemoData124"

$connStr = "Server=tcp:bphdemos.database.windows.net,1433;Initial Catalog=AdventureWorks;" `
    + "Persist Security Info=False;User ID=$userStr;Password=$passwdStr;" `
    + "MultipleActiveResultSets=False;Encrypt=True;" `
    + "TrustServerCertificate=False;Connection Timeout=30;"

