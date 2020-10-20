# Create a CSV file
"Alias,Value" | Out-File C:\Scripts\Demo.csv
"D,Get-ChildItem" | Out-File C:\Scripts\Demo.csv -Append
"S,Get-Service" | Out-File C:\Scripts\Demo.csv -Append

# Won't work because there's no Name column
Import-CSV c:\Scripts\demo.csv

# Fix it
Import-CSV c:\Scripts\demo.csv | 
Select-Object -Property Value,@{n='Name';e={$_.Alias}}

# Now that could be piped to New-Alias