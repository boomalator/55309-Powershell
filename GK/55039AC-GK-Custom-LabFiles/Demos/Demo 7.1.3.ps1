# Assumes you've copied the demo script 7.1.2.ps1 to
# C:\Scripts\Debug.ps1.
Set-PSBreakpoint -Script C:\Scripts\debug.ps1 -Variable totalbought,totalsold -Mode ReadWrite

# Run the script
C:\Scripts\Debug.ps1

# At the breakpoint, follow the command shown in the book
# to demonstrate. The revised script is in Demo 7.1.3B.