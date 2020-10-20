$a = get-childitem $args[0] | select-object mode, name
foreach ($i in $a)
{
If ($i.mode -eq “d----“)
{write-host $i.name -foregroundcolor “green”}
else
{write-host $i.name}
}
