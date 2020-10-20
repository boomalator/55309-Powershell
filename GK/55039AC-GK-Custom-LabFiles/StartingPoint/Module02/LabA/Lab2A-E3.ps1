Get-WmiObject –Class Win32_OperatingSystem –ComputerName Bravo |
  Invoke-WmiMethod –Name Win32Shutdown –Arg 4 |
  Out-Null
