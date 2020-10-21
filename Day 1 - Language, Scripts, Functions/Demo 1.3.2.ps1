# put a value to play with
$var = 'hello'

# single quotes
$single = 'say $var'
$single

# double quotes
$double = "say $var"
$double

# add a complex object to a variable
$services = Get-Service

# this will not work
$bad = "Service name is $services[0].name"

# this will work - it's a subexpression
$good = "Service name is $($services[0].name)"

# note that the ISE properly color-codes variables and
# subexpressions inside double quotes

# only the outer set of quotes matter
$double = "say '$var'"
$double

