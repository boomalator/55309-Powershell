$computers = 'Alpha','Bravo','Echo'
foreach ($computer in $computers) {
    Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer
}