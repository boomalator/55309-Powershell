$sitename = read-host “Enter the name for the Site”

import-module WebAdministration

dnscmd /recordadd hq.local $sitename cname alpha.hq.local

test-connection $sitename

$sitedir = "D:\" + $sitename

new-item -path $sitedir -type directory

$sitedefaultdoc = "D:\" + $sitename + "\default.htm"

$sitehtml = "<H1>Welcome to the " + $sitename + " Website!<H1>"

write-output $sitehtml > $sitedefaultdoc

$sitehostheader = $sitename + ".hq.local"

new-website $sitename -hostheader $sitehostheader -physicalpath $sitedir

$siteurl = "http://" + $sitename + ".hq.local"  

. "C:\program files\internet explorer\iexplore.exe" $siteurl
