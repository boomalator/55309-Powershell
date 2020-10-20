# run this entire script
[int]$age = Read-Host "What is your age?"

if ($age -lt 18) {
    Write "You're a young one!"
} elseif ($age -lt 65) {
    Write "Not quite ready for retirement!"
} elseif ($age -lt 100) {
    Write "You should be enjoying the good life!"
} else {
    Write "Wow, that's old!"
}
