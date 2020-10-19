
function say-Hello {
    Write-Host "Hello World!" -ForegroundColor White
}
function get-DateDifference { 
    [CmdletBinding()]
    param (
        [datetime] $dpast ,
        [datetime] $dtoday = (get-date)
    )

    #$dtoday = [datetime] 'October 19,2020'
    #$dpast = [datetime] 'December 6, 1944'

    $diff = New-TimeSpan -Start $dpast -End $dtoday
    Write-Output "Time difference is: $($diff.TotalDays/365.25) years"
}

get-DateDifference -dpast 'September 11, 1911'
get-DateDifference -dpast 'September 11, 1939'
get-DateDifference -dpast 'September 11, 1973'

