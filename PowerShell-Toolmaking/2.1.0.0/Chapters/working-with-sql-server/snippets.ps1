Return "This is a snippets file not a script to run."


# create a connection
```PowerShell
$conn = New-Object -Type System.Data.SqlClient.SqlConnection
$conn.ConnectionString = 'Server=SQL1;Database=MyDB;Trusted_Connection=True;'
$conn.Open()
```


# INSERT model
INSERT INTO <tablename>
    (Column1, Column2, Column3)
    VALUES (Value1, Value2, Value3)


# INSERT example
$ComputerName = "SERVER2"
$OSVersion = "Win2012R2"
$query = "INSERT INTO OSVersion (ComputerName,OS) VALUES('$ComputerName','$OSVersion')"



# DELETE model
DELETE FROM <tablename> WHERE <criteria>


# DELETE example
$query = "DELETE FROM OSVersions WHERE ComputerName = '$ComputerName'"



# UPDATE model
UPDATE <tablename>
   SET <column> = <value>, <column> = <value>
   WHERE <criteria>


# UPDATE example
$query = "UPDATE DiskSpaceTracking `
          SET FreeSpaceOnSysDrive = $freespace `
          WHERE ComputerName = '$ComputerName'"



# SELECT model
SELECT <column>,<column>
       FROM <tablename>
       WHERE <criteria>
       ORDER BY <column>


# SELECT example
$query = "SELECT DiskSpace,DateChecked `
          FROM DiskSpaceTracking `
          WHERE ComputerName = '$ComputerName' `
          ORDER BY DateChecked DESC"



# CREATE TABLE model
CREATE TABLE <tablename> (
    <column> <type>,
    <column> <type>
)



# Set up to run a query
$command = New-Object -Type System.Data.SqlClient.SqlCommand
$command.Connection = $conn
$command.CommandText = $query



# Run INSERT/UPDATE/DELETE
$command.ExecuteNonQuery()



# Run SELECT
$reader = $command.ExecuteReader()



# Read through rows
while ($reader.read()) {
  #do something with the data
}



# Full example
$conn = New-Object -Type System.Data.SqlClient.SqlConnection
$conn.ConnectionString = 'Server=SQL1;Database=MyDB;Trusted_Connection=True;'
$conn.Open()

$query = "SELECT ComputerName,DiskSpace,DateTaken FROM DiskTracking"

$command = New-Object -Type System.Data.SqlClient.SqlCommand
$command.Connection = $conn
$command.CommandText = $query
$reader = $command.ExecuteReader()

while ($reader.read()) {
    [pscustomobject]@{'ComputerName' = $reader.GetValue(0)
                         'DiskSpace' = $reader.GetValue(1)
                         'DateTaken' = $reader.GetValue(2)
                        }
}

$conn.Close()



# Let it figure out ordinals for you
while ($reader.read()) {
    [pscustomobject]@{
    'ComputerName' = $reader.GetValue($reader.getordinal("computername"))
    'DiskSpace' = $reader.GetValue($reader.getordinal("diskspace"))
    'DateTaken' = $reader.GetValue($reader.getordinal("datetaken"))
    }
}




# Invoke-Sqlcmd
Invoke-Sqlcmd "Select Computername,Diskspace,DateTaken from DiskTracking" `
-Database MyDB
