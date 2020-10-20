$username=read-host "Enter User Name"
$userpass=read-host "Enter Password" `
-AsSecureString
$oupath=read-host "Enter OU Path"
import-module activedirectory
new-aduser -name $username ` 
-samaccountname $username -givenname $username `
-userprincipalname $username@hq.local `
-path $oupath -enabled $true `
-changepasswordatlogon $false `
-accountpassword $userpass
