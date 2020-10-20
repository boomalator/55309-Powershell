#####################################
#     LabTrek creation script		#
#								#
#		by:  Mark Morgan			#
#								#
#	This script will create the OUs#
#	groups and users required for	#
#	for the labs in this course.	#
#								#
#	See if you can simplify this	#
#	script by using variables and	#
#	creating functions.			#
#####################################

[reflection.assembly]::loadwithpartialname('system.windows.forms')
$buttonpress = [system.Windows.Forms.MessageBox]::show('About to run the PowerShell script LabTrek.ps1 to build the user acccount structure. Click OK to run the script.','LabTrek Build',[Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Warning, [System.Windows.Forms.MessageBoxDefaultButton]::Button1)
if ($buttonpress -eq "Cancel") {
    $buttonpress2 = [system.Windows.Forms.MessageBox]::show('Build Cancelled!','LabTrek Build',[Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Exclamation, [System.Windows.Forms.MessageBoxDefaultButton]::Button2)
    exit
}

import-module activedirectory

trap { continue }

new-adorganizationalunit Accounts -path "dc=hq,dc=local"
new-adorganizationalunit Engineering -path "ou=Accounts,dc=hq,dc=local"
new-adorganizationalunit IT -path "ou=Accounts,dc=hq,dc=local"
new-adorganizationalunit Management -path "ou=Accounts,dc=hq,dc=local"
new-adorganizationalunit Sales -path "ou=Accounts,dc=hq,dc=local"
new-adorganizationalunit "East Coast" -path "ou=Sales,ou=Accounts,dc=hq,dc=local"
new-adorganizationalunit "West Coast" -path "ou=Sales,ou=Accounts,dc=hq,dc=local"

New-ADGroup "Eng Admins" -GroupCategory Security -GroupScope Global -Path "ou=Engineering,ou=Accounts,dc=hq,dc=local"
New-ADGroup "Eng Users" -GroupCategory Security -GroupScope Global -Path "ou=Engineering,ou=Accounts,dc=hq,dc=local"

New-ADGroup "IT Admins" -GroupCategory Security -GroupScope Global -Path "ou=IT,ou=Accounts,dc=hq,dc=local"
New-ADGroup "Help Desk" -GroupCategory Security -GroupScope Global -Path "ou=IT,ou=Accounts,dc=hq,dc=local"

New-ADGroup "Executives" -GroupCategory Security -GroupScope Global -Path "ou=Management,ou=Accounts,dc=hq,dc=local"

New-ADGroup "Sales Admins" -GroupCategory Security -GroupScope Global -Path "ou=Sales,ou=Accounts,dc=hq,dc=local"
New-ADGroup "Sales Users" -GroupCategory Security -GroupScope Global -Path "ou=Sales,ou=Accounts,dc=hq,dc=local"

New-AdUser Scooty -samaccountname Scooty -givenname Scooty -userprincipalname Scooty@hq.local -path "ou=Engineering,ou=accounts,dc=hq,dc=local" -enabled $true -changepasswordatlogon $false -accountpassword (convertto-securestring "TrustM3" -asplaintext -force)
New-AdUser SooLoo -samaccountname SooLoo -givenname SooLoo -userprincipalname SooLoo@hq.local -path "ou=Engineering,ou=accounts,dc=hq,dc=local" -enabled $true -changepasswordatlogon $false -accountpassword (convertto-securestring "TrustM3" -asplaintext -force)
Add-ADGroupMember "Eng Admins" Scooty,SooLoo
Add-ADGroupMember "Eng Users" SooLoo

New-AdUser Speck -samaccountname Speck -givenname Speck -userprincipalname Speck@hq.local -path "ou=IT,ou=accounts,dc=hq,dc=local" -enabled $true -changepasswordatlogon $false -accountpassword (convertto-securestring "TrustM3" -asplaintext -force)
New-AdUser Ohara -samaccountname Ohara -givenname Ohara -userprincipalname Ohara@hq.local -path "ou=IT,ou=accounts,dc=hq,dc=local" -enabled $true -changepasswordatlogon $false -accountpassword (convertto-securestring "TrustM3" -asplaintext -force)
Add-ADGroupMember "IT Admins" Speck,Ohara
Add-ADGroupMember "Help Desk" Speck,Ohara
Add-ADGroupMember "Domain Admins" Speck
Add-ADGroupMember "Enterprise Admins" Speck

New-AdUser Quirk -samaccountname Quirk -givenname Quirk -userprincipalname Quirk@hq.local -path "ou=Management,ou=accounts,dc=hq,dc=local" -enabled $true -changepasswordatlogon $false -accountpassword (convertto-securestring "TrustM3" -asplaintext -force)
Add-ADGroupMember "Executives" Quirk
Add-ADGroupMember "Domain Admins" Quirk
Add-ADGroupMember "Enterprise Admins" Quirk

New-AdUser MackOy -samaccountname MackOy -givenname MackOy -userprincipalname MackOy@hq.local -path "ou=Sales,ou=accounts,dc=hq,dc=local" -enabled $true -changepasswordatlogon $false -accountpassword (convertto-securestring "TrustM3" -asplaintext -force)
New-AdUser Checkoff -samaccountname Checkoff -givenname Checkoff -userprincipalname Checkoff@hq.local -path "ou=Sales,ou=accounts,dc=hq,dc=local" -enabled $true -changepasswordatlogon $false -accountpassword (convertto-securestring "TrustM3" -asplaintext -force)
Add-ADGroupMember "Sales Admins" MackOy
Add-ADGroupMember "Help Desk" MackOy
Add-ADGroupMember "Sales Users" Checkoff

$buttonpress2 = [system.Windows.Forms.MessageBox]::show('Finished creating accounts and OUs!','LabTrek Build',[Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information, [System.Windows.Forms.MessageBoxDefaultButton]::Button2)
