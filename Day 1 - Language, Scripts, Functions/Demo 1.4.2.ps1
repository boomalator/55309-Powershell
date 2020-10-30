# Run this section first:
[int]$drivetype = Read-Host "Enter a drive type 0-6"

switch ($drivetype) {
    0 { Write "Unknown"  }
    1 { Write "No root" }
    2 { Write "Removable" }
    3 { Write "Local" }
    4 { Write "Network" }
    5 { Write "Optical" }
    6 { Write "RAM" }
}

# Run this section next:
[string]$computer = Read-Host "Enter a computer name like NYC-DC1"

switch -Wildcard ($computer) {
    '*DC*' { Write "Domain Controller" }
    '*SQL*' { Write "SQL Server" }
    '*EX*' { Write "Exchange" }
    '*NYC*' { Write "New York City" }
    '*LON*' { Write "London" }
    '*LAS*' { Write "Las Vegas" }
}

# Run this section last:
[string]$computer = Read-Host "Enter a computer name like NYC-DC1"

switch -Wildcard ($computer) {
    '*DC*' { Write "Domain Controller"; break }
    '*SQL*' { Write "SQL Server"; break }
    '*EX*' { Write "Exchange"; break }
    '*NYC*' { Write "New York City"; break }
    '*LON*' { Write "London"; break }
    '*LAS*' { Write "Las Vegas"; break }
}