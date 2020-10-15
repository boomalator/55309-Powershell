# More examples: https://ss64.com/ps/set-strictmode.html
# Documentation: get-help set-strictmode
# V7 Docs: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-strictmode?view=powershell-7
 

 Set-StrictMode -Version 1
 #Set-StrictMode -version latest
 
 ## Make a custom object with one property:
 $someObject = [pscustomobject]@{ SomeProperty = 'foo'  }

 # Use a nonexistent property of the object:
 if ($someObject.NonExistentProperty) {
    Write-Host  'NonExistentProperty' exists
 } else {
    Write-Host  'NonExistentProperty' does not exist
 }

 # how about an "undeclared" variable?
 if ($x -gt 5) {
    Write-Host "X is big"
 } else {
    Write-Host "X is little"
 }

#using "Method Syntax"
function add  ($a, $b) {
    '$a = ' + $a
    '$b = ' + $b
    '$a+$b = ' + ($a + $b)
}
add 3 4
add(3,4)
add (3,4)


# Array Bounds
$arrrgh = @(1)
$arrrgh[0]
$arrrgh[2] -eq $null
$arrrgh['abc'] -eq $null
$arrrgh['0'] -eq $null
