function one {
    Param()
    Write-Host "This is One" -ForegroundColor White
}

function two {
    [CmdletBinding()]
    Param()
    Write-Host "This is Two" -ForegroundColor Green
}

function three {
    Param()
    Write-Host "Tthrehis is Three" -ForegroundColor Cyan
    Write-Verbose "[3] Let's be a Chatty Kathy"
    Write-Debug "[3] This is a bit of trivia"
}

function four {
    [CmdletBinding()]
    Param()
    Write-Host "This is Four" -ForegroundColor Yellow
    Write-Verbose "[4] Let's be a Chatty Kathy"
    Write-Debug "[4] This is a bit of trivia"
}

<# 

Key benefits from using CmdletBinding:
 - Advanced Parameters (The [Parameter()] decorator)
 - Write-Verbose/Write-Debug support with -Debug and -Verbose switches
 - Common Parameters (see about_common_parameters) including -EA and -EV
 - Support for -WhatIf and -Confirm using ShouldProcess()

#>

<#

get-help one
get-help two

three
four

three -debug
four -debug

three -verbose
four -verbose

#>


function five {
    [CmdletBinding()]
    Param()
    Write-Verbose "This is Five" 
    For ($i=1;$i -le 10; $i++) {
       Write-Verbose "Loop Starting"
       Write-Host "This is loop #$i" -ForegroundColor Green
       Write-Verbose "Loop Ending"
    }
}


function echo-ComputerName {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    Param(
        [string[]]$ComputerName = "Echo"
    )
    
    BEGIN {
        Write-Verbose "Function Six Starting" 
    }
    
    PROCESS{
        Foreach ($computer in $ComputerName) {
            if ( $PSCmdlet.ShouldProcess("$computer" ) )
            {
                Write-Host "Echoing the computer name, which is $computer." -ForegroundColor Yellow
            }
        }
    }
    
    END {
        Write-Verbose "Function Six Ending"
    }
}
