

function get-DateDifference { 
    [CmdletBinding()]
    param (
        [datetime] $dpast ='1944/12/06',
        [datetime] $dtoday = (get-date)
    )

    $diff = New-TimeSpan -Start $dpast -End $dtoday
    Write-Output "Time difference is: $($diff.TotalDays/365.25) years"
}



get-DateDifference -dpast 'September 11, 1911'
get-DateDifference -dpast 'September 11, 1939'
get-DateDifference -dpast 'September 11, 1973'

