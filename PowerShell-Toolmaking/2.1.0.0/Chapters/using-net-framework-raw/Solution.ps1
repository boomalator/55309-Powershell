function ConvertTo-RoundNumber {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [double]$Number,

        [int]$DecimalPlaces
    )
    
    if ($PSBoundParameters.ContainsKey('DecimalPlaces')) {
        [System.Math]::Round($Number, $DecimalPlaces) 
    } 
    else {
        [System.Math]::Round($Number)
    }
}

ConvertTo-RoundNumber -Number 5.55345 -DecimalPlaces 2
ConvertTo-RoundNumber -Number 5.6748