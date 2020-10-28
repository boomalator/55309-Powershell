<# Part 1 
here's the script - no need to run it yet
the formatting makes this hard to read
#>
$data = import-csv c:\Scripts\data.csv
$totalqty = 0
$totalsold = 0
$totalbought = 0
foreach ($line in $data) {
if ($line.transaction -eq 'buy') {
    # buy transaction (we sold)
    $totalqty -= $line.qty
    $totalsold = $line.total } else {
    # sell transaction (we bought)
    $totalqty += $line.qty
    $totalbought = $line.total }
"totalqty,totalbought,totalsold,totalamt" | out-file c:\Scripts\summary.csv
"$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
 out-file c:\Scripts\summary.csv -append

