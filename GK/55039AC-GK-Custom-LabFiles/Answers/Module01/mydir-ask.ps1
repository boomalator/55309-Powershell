$q = read-host “Enter a path to a folder”
$a = get-childitem $q | select-object mode, name
foreach ($i in $a)
{
If ($i.mode -eq “d----“)
{write-host $i.name -foregroundcolor “green”}
else
{write-host $i.name}
}