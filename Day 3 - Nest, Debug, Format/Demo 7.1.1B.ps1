# Create sample CSV file
# highlight and run these lines:
"name,transaction,qty,amount,total" | Out-File c:\Scripts\data.csv
"ctgannon,buy,4,3.00,12.00"  | Out-File c:\Scripts\data.csv -Append
"gshields,sell,1200,1.00,1200.00" | Out-File c:\Scripts\data.csv -Append
"tevans,sell,8,9.00,72.00" | Out-File c:\Scripts\data.csv -Append

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


<# Part 2
Start by fixing up the formatting, and look
for immediate syntactical problems.
#>
$data = import-csv c:\Scripts\data.csv
$totalqty = 0
$totalsold = 0
$totalbought = 0
foreach ($line in $data) {
    if ($line.transaction -eq 'buy') {
        # buy transaction (we sold)
        $totalqty -= $line.qty
        $totalsold = $line.total
    } else {
        # sell transaction (we bought)
        $totalqty += $line.qty
        $totalbought = $line.total
    }
"totalqty,totalbought,totalsold,totalamt" | out-file c:\Scripts\summary.csv
"$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
    out-file c:\Scripts\summary.csv –append


<#
Part 3
Just reviewing that should have revealed a problem
with the foreach loop; let's fix it (line 70)
#>
$data = import-csv c:\Scripts\data.csv
$totalqty = 0
$totalsold = 0
$totalbought = 0
foreach ($line in $data) {
    if ($line.transaction -eq 'buy') {
        # buy transaction (we sold)
        $totalqty -= $line.qty
        $totalsold = $line.total
    } else {
        # sell transaction (we bought)
        $totalqty += $line.qty
        $totalbought = $line.total
    }
}
"totalqty,totalbought,totalsold,totalamt" | out-file c:\Scripts\summary.csv
"$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
    out-file c:\Scripts\summary.csv –append


<#
Part 4
Now before we run the script, let's validate assumptions. 
Look at (but don't run) these four lines. What do they do?
What will the variables contain?
#>
$data = import-csv c:\Scripts\data.csv
$totalqty = 0
$totalsold = 0
$totalbought = 0

# Therefore, what will this do?
foreach ($line in $data) {
}

# Within that ForEach, what will these lines do?
if ($line.transaction -eq 'buy') {
    # buy transaction (we sold)
    $totalqty -= $line.qty
    $totalsold = $line.total
} else {
    # sell transaction (we bought)
    $totalqty += $line.qty
    $totalbought = $line.total
}

# and then finally, what will the last line do?
"totalqty,totalbought,totalsold,totalamt" | out-file c:\Scripts\summary.csv
"$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
    out-file c:\Scripts\summary.csv -append


<# Part 5
Now run the script - highlight lines 56-73 and press F8.
#>