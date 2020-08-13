Function Out-CatFact {
    $fact = (ConvertFrom-Json (Invoke-WebRequest -uri  https://cat-fact.herokuapp.com/facts/random)).text
    Write-Host $fact -ForegroundColor Cyan
}

Out-CatFact