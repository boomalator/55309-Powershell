# Create a CSV file
"Name,Value" | Out-File C:\Scripts\Demo.csv
"D,Get-ChildItem" | Out-File C:\Scripts\Demo.csv -Append
"S,Get-Service" | Out-File C:\Scripts\Demo.csv -Append

# Check it
Import-CSV c:\Scripts\Demo.csv

# use it
Import-CSV C:\Scripts\Demo.csv | New-Alias

# use the new aliases
D
S
