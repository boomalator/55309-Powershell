    
    param (
        [datetime]$dtoday = (get-date) ,
        [datetime]$dpast = '1944/12/06'
    )

    $diff = New-TimeSpan -Start $dpast -End $dtoday
    Write-Output "Time difference between $dpast and $dtoday is: $($diff.TotalDays/365.25) years"