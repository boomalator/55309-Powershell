import-module activedirectory

md  c:\scripts -erroraction:silentlycontinue
cls
write-host "Enter the root path to process from:`n"

Write-host "Examples:  D:\Docs   ad:\ou=accounts,dc=hq,dc=local`n"
$RootPath = read-host "Root Path = "

write-host "Getting ACL Listing of: $RootPath" 

Del c:\scripts\acls.txt -erroraction:silentlycontinue

foreach ($item in get-childitem $RootPath -recurse) {get-acl $item.pspath | format-list -property pspath, accesstostring >> c:\scripts\acls.txt};notepad  c:\scripts\acls.txt
