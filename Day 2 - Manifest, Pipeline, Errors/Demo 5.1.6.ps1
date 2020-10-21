# create a CSV
"Hostname" | Out-File c:\Scripts\hosts.csv
"Alpha" | Out-File c:\Scripts\hosts.csv -append
"Bravo" | Out-File c:\Scripts\hosts.csv -append

# test it
Import-CSV c:\Scripts\hosts.csv

# a hostname property is useless - we need a flat-out string
Import-CSV c:\Scripts\hosts.csv | Select -Property hostname

# that wasn't a string; it was an object with just a hostname property
Import-CSV c:\Scripts\hosts.csv | Select -ExpandProperty hostname

# that was a plain string
Get-Process -ComputerName (Import-CSV c:\Scripts\hosts.csv | Select -Expand hostname)