$getinput = read-host "Enter a list of computer names separated by commas and no spaces"
$hostnames = $getinput.split(",")
foreach ($thishost in $hostnames)
{
ping -n 1 $thishost
}
