Get-WmiObject –Class Win32_OperatingSystem –ComputerName Bravo | 
  Select-Object Version,ServicePackMajorVersion,BuildNumber,OSArchitecture 
