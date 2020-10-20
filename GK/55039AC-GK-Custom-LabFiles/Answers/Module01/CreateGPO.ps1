Import-Module grouppolicy
Import-Module activedirectory

# Ask the user for GPO Names
$getgpo = Read-Host "Enter a list of GPOs separated by commas"

# Split the GPO names into an array for processing
$gponames = $getgpo.split(",")

# Loop through the array of names to create the GPOs
foreach ($gpoitem in $gponames) {
	New-GPO $gpoitem | Out-Null
}

# Display a list of OU names
Get-ADOrganizationalUnit -Filter 'name -like "*"' | Format-Table Name

# Ask for the destination OU
$getou = Read-Host "Enter the OU to link the GPO to"

#Find the OU object that corresponds to the OU name
$ouobject = Get-ADOrganizationalUnit -Filter 'name -like $getou'

#Loop through each GPO name and link to the OU
foreach ($gpoitem in $gponames) {
	New-GPLink $gpoitem -Target $ouobject
}
