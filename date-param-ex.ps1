
$diff = New-TimeSpan -Start 'September 19,2020' -End 'December 6, 1944'
Write-Output "Time difference is: $($diff.TotalDays/365.25) years"




$dtoday = [datetime] 'September 19,2020'
$dpast = [datetime] 'December 6, 1944'
$diff = New-TimeSpan -Start $dpast -End $dtoday
Write-Output "Time difference is: $($diff.TotalDays/365.25) years"


