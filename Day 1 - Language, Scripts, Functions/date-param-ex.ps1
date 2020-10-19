
# $diff = New-TimeSpan -End 'October 19,2020' -Start 'November 27, 1987'
# Write-Output "Time difference is: $($diff.TotalDays/365.25) years"

$dtoday = [datetime] 'October 19,2020'
$dpast = [datetime] 'December 6, 1944'

$diff = New-TimeSpan -Start $dpast -End $dtoday
Write-Output "Time difference is: $($diff.TotalDays/365.25) years"


