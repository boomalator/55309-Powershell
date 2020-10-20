Get-WmiObject –Class Win32_LogicalDisk –Filter "DriveType=3" –Computer Bravo |
  Where-Object { $_.FreeSpace / $_.Size * 100 –lt 99 } 
