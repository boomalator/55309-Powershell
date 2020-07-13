Return "This is a snippets file not a script to run."

# insert a custom name
$obj.psobject.TypeNames.Insert(0,"TMComputerStatus")



# extending with update-typedata
$myType = "TMComputerStatus"

$myType = "TMComputerStatus"

Update-TypeData -TypeName $myType -DefaultDisplayPropertySet  'ComputerName','Uptime','PctFreeMem','PctFreeC'
Update-TypeData -TypeName $myType -MemberType AliasProperty -MemberName Memory -Value TotalMem -force

Update-TypeData -TypeName $myType -MemberType ScriptMethod -MemberName Ping `
                                  -Value { 
                                    Test-NetConnection $this.computername 
                                   } -force 

Update-TypeData -TypeName $myType -MemberType ScriptProperty -MemberName `
                              TopProcesses -Value { 
                              Get-Process -ComputerName $this.computername |
                              Sort-Object -Property WorkingSet -Descending |
                              Select-Object -first 5
                              } -force



