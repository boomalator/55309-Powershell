# what kind of object is produced by Get-Content?
'Alpha','Bravo' | Out-File c:\Scripts\computers.txt
Get-Content c:\Scripts\computers.txt | Get-Member

# a STRING. So any command that has a parameter which:
# (a) accepts one or more strings     <string[]>
# (b) from the pipeline ByValue
# can accept piped input from Get-Content

Get-Content c:\Scripts\computers.txt |
Get-Service -Name *

