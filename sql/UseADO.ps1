# Using ADO.net
#

# open a connection
# Note: Azure will require you to allow client access. 
# Firewalls are a thing, too.

$sqlConn = New-Object System.Data.SqlClient.SqlConnection
$sqlConn.ConnectionString = $connstr
$sqlConn.Open()       

# build a query
$sqlcmd = $sqlConn.CreateCommand()
<# or
    $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
    $sqlcmd.Connection = $sqlConn
#>

# $query = "SELECT name, database_id FROM sys.databases"
$query = "SELECT top 20 * from [SalesLT].[Customer]"
$sqlcmd.CommandText = $query

# Create a data adapter, an object that "represents a set of data commands
# and a database connection that are used to fill the DataSet". 
$adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd

# Create and fill a dataset
$data = New-Object System.Data.DataSet
$adp.Fill($data)  # you can supress the row-count with: $adp.Fill($data)| Out-Null

# now you can work with your data:
$data.Tables
# $data.Tables[0]

$data.Tables[0] | Export-Csv "c:\sql\customersFromAzure.csv"

# explicitly close your connection
$sqlConn.Close()
