﻿# Scope Demo

function countup {
    Write-Host "Starting -" $a -ForegroundColor Cyan
    $a = "Count Up"
    Write-Host $a -ForegroundColor Cyan
    Write-Host 'Outside (before) the loop in the countup function, $i is' $i -ForegroundColor DarkCyan
    for ($i = 1; $i -le 3; $i++) {
        Write-Host 'Inside the loop in the countup function, $i is' $i -ForegroundColor Cyan
    }
    Write-Host 'Outside (after) the loop in the countup function, $i is' $i -ForegroundColor DarkCyan
}

function countdown {
    Write-Host "Starting -" $a -ForegroundColor Cyan
    $a = "Count Down"
    Write-Host $a -ForegroundColor Cyan
    Write-Host 'Outside (before) the loop in the countdown function, $i is' $i -ForegroundColor DarkCyan
    for ($i = 10; $i -ge 7; $i--) {
        Write-Host 'Inside the loop in the countdown  function, $i is' $i -ForegroundColor Cyan
    }
    Write-Host 'Outside (after) the loop in the countdown  function, $i is' $i -ForegroundColor DarkCyan
}

Write-Host "Starting The Script." -ForegroundColor Yellow
Write-Host 'Before the loop, script $i is' $i -ForegroundColor DarkYellow
Write-Host 'Before the loop, script $a is' $a -ForegroundColor DarkYellow

for ($i = 1; $i -le 3; $i++) {
    Write-Host 'Inside the script Loop, $i is' $i -ForegroundColor Yellow
    countup
    countdown
}

Write-Host 'After the loop, script $i is' $i -ForegroundColor DarkYellow
Write-Host 'After the loop, script $a is' $a -ForegroundColor DarkYellow

$b = "Script"
Write-Host 'After the end, script $b is' $b -ForegroundColor DarkYellow