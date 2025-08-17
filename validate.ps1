# Simple Lua syntax validator for common errors
$content = Get-Content "scriptdeltafishit.lua" -Raw

Write-Host "=== Lua Script Validation ==="

# Check for common syntax errors
$errors = @()

# Check for unmatched brackets
$openBrackets = ([regex]::Matches($content, '\{') | Measure-Object).Count
$closeBrackets = ([regex]::Matches($content, '\}') | Measure-Object).Count
if ($openBrackets -ne $closeBrackets) {
    $errors += "Unmatched curly brackets: $openBrackets open, $closeBrackets close"
}

# Check for unmatched parentheses  
$openParens = ([regex]::Matches($content, '\(') | Measure-Object).Count
$closeParens = ([regex]::Matches($content, '\)') | Measure-Object).Count
if ($openParens -ne $closeParens) {
    $errors += "Unmatched parentheses: $openParens open, $closeParens close"
}

# Check for function definitions vs ends
$functions = ([regex]::Matches($content, 'local function|function ') | Measure-Object).Count
$ends = ([regex]::Matches($content, '(?m)^end$|(?m)^\s*end$') | Measure-Object).Count
Write-Host "Functions: $functions, Ends: $ends"

# Check for common nil errors
if ($content -match "local\s+\w+\s*=\s*nil") {
    $errors += "Found explicit nil assignments"
}

# Check for incomplete if statements
$ifStatements = ([regex]::Matches($content, '\bif\b') | Measure-Object).Count
$elseStatements = ([regex]::Matches($content, '\belse\b') | Measure-Object).Count
$endStatements = ([regex]::Matches($content, '\bend\b') | Measure-Object).Count

Write-Host "If statements: $ifStatements"
Write-Host "Total ends: $endStatements"

if ($errors.Count -eq 0) {
    Write-Host "✅ No obvious syntax errors found!"
} else {
    Write-Host "❌ Potential errors found:"
    $errors | ForEach-Object { Write-Host "  - $_" }
}

Write-Host "`n=== File Stats ==="
$lines = (Get-Content "scriptdeltafishit.lua" | Measure-Object -Line).Lines
Write-Host "Total lines: $lines"
Write-Host "File size: $((Get-Item 'scriptdeltafishit.lua').Length) bytes"
