# Put several computer names into a file
'Alpha','Bravo','Echo' | Out-File C:\Scripts\testnames.txt

# Read that content
Get-Content c:\Scripts\testnames.txt

# Use in a parenthetical expression
Get-WmiObject -Class Win32_BIOS -ComputerName (Get-Content c:\Scripts\testnames.txt)

# Another example
# (may return one or more errors as some computers aren't enabled for this)
Invoke-Command -ScriptBlock { Dir C:\ } -ComputerName (Get-Content c:\Scripts\testnames.txt)