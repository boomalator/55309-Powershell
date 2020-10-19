# Scope Demo

function countup {
    Write-Host "Starting -" $a -ForegroundColor Cyan
    $a = "Count Up"
    Write-Host $a -ForegroundColor Cyan
    Write-Host 'Outside (before) the loop in the countup function, $i is' $i -ForegroundColor DarkCyan
    for ($i = 10; $i -le 13; $i++) {
        Write-Host 'Inside the loop in the countup function, $i is' $i -ForegroundColor Cyan
    }
    Write-Host 'Outside (after) the loop in the countup function, $i is' $i -ForegroundColor DarkCyan
}

function countdown {
    Write-Host "Starting -" $a -ForegroundColor Cyan
    $a = "Count Down"
    Write-Host $a -ForegroundColor Cyan
    Write-Host 'Outside (before) the loop in the countdown function, $i is' $i -ForegroundColor DarkCyan
    for ($i = 99; $i -ge 97; $i--) {
        Write-Host 'Inside the loop in the countdown  function, $i is' $i -ForegroundColor Cyan
    }
    Write-Host 'Outside (after) the loop in the countdown  function, $i is' $i -ForegroundColor DarkCyan
}

Write-Host "Starting The Script." -ForegroundColor Yellow
Write-Host 'Before the loop, script $i is' $i -ForegroundColor DarkYellow
Write-Host 'Before the loop, script $a is' $a -ForegroundColor DarkYellow

for ($i = 100; $i -le 103; $i++) {
    Write-Host 'Inside the script Loop, $i is' $i -ForegroundColor Yellow
    countup
    countdown
}

Write-Host 'After the loop, script $i is' $i -ForegroundColor DarkYellow
Write-Host 'After the loop, script $a is' $a -ForegroundColor DarkYellow

$a = 3333
Write-Host 'After the end, $a is now is' $a -ForegroundColor DarkYellow


$b = "Script"
Write-Host 'After the end, script $b is' $b -ForegroundColor DarkYellow



