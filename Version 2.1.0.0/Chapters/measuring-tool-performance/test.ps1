Write-Host "Round 1" -ForegroundColor Green
Measure-Command -Expression {
    Get-Service | 
    ForEach-Object { $_.Name }
}

Write-Host "Round 2" -ForegroundColor Yellow
Measure-Command -Expression {
    Get-Service | 
    Select-Object Name
}

Write-Host "Round 3" -ForegroundColor Cyan
Measure-Command -Expression {
    ForEach ($service in (Get-Service)) {
        $service.name
    }
}
