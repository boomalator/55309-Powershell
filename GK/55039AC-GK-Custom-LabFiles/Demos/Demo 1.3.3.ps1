# put an object - a string - into a variable
$s = "PowerShell"

# display members
$s | Get-Member

# use a property
$s.Length

# use a method
$s.ToUpper()

# complex objects
$services = Get-Service
$services[0].Name.ToUpper()
