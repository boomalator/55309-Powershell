$a = get-childitem $args[0] | select-object mode, name
foreach ($i in $a)
{
If ($i.mode -eq “-a---“)
{write-host $i.name -foregroundcolor “red”}
else
{write-host $i.name -foregroundcolor "green"}
}
