function Show-Hello {
    [CmdletBinding()]
    param( 
        [System.ConsoleColor] $ForegroundColor = 'Cyan'
    )

    Write-Host "Hello, World" -ForegroundColor $ForegroundColor
    
}