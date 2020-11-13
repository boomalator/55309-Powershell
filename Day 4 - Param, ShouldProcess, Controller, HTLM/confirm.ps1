function Test-ConfimHigh {
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    param (
    )
    if ($PSCmdlet.ShouldProcess("High")){
        Write-Host "Doing the High-Impact Thing now..."
    }
}

function Test-ConfimMedium {
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Medium")]
    param (
    )
    if ($PSCmdlet.ShouldProcess("Medium")){
        Write-Host "Doing the Medium-Impact Thing now..."
    }
}

function Test-ConfimLow {
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    param (
    )
    if ($PSCmdlet.ShouldProcess("Low")){
        Write-Host "Doing the Low-Impact Thing now..."
    }
}
cls
"The ConfirmPreference is $ConfirmPreference"
Test-ConfimLow
Test-ConfimMedium
Test-ConfimHigh

Test-ConfimHigh -Confirm:$false