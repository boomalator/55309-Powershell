# We've added [CmdletBinding()] and Param()
# to enable the -Debug switch. Run this script
# FROM THE CONSOLE, adding -Debug to it.
# Then proceed to Demo 7.1.2B for instructions.

# Recommend copying this script to C:\Scripts\Debug.ps1 and
# running it from there with "C:\Scripts\Debug.ps1 -debug"

[CmdletBinding()]
param()
$data = import-csv c:\Scripts\data.csv
Write-Debug "Imported CSV data"

$totalqty = 0
$totalsold = 0
$totalbought = 0
foreach ($line in $data) {
    if ($line.transaction -eq 'buy') {

        Write-Debug "ENDED BUY transaction (we sold)"
        $totalqty -= $line.qty
        $totalsold = $line.total

    } else {

        $totalqty += $line.qty
        $totalbought = $line.total
        Write-Debug "ENDED SELL transaction (we bought)"

    }
}

Write-Debug "OUTPUT: $totalqty,$totalbought,$totalsold,
[CA]$($totalbought-$totalsold)"

"totalqty,totalbought,totalsold,totalamt" | out-file c:\Scripts\summary.csv
"$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
    out-file c:\Scripts\summary.csv –append

