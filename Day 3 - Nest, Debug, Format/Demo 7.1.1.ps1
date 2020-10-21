<#
Part 1: This is the buggy command
What will this do? What is the EXPECTATION?
What SHOULD happen? What is the INTENDED OUTPUT?
#>
Get-CimInstance -class Win32_LogicalDisk `
                -filter "drivetype='fixed'" |
Select -Property DeviceID,Size |
Sort -Property FreeSpace 



<#
Part 2: The next step is to start with just
a single command instead of a whole pipeline.
This helps narrow down the source of the error.
#>
Get-CimInstance -class Win32_LogicalDisk `
                -filter "drivetype='fixed'"


<#
Part 3: Now start removing parameters until
the error is gone
#>
Get-CimInstance -class Win32_LogicalDisk


<#
Part 4: Once it works, pipe the output to GM
and verify expectations - in this case,
DriveType is a number, not a string.
#>
Get-CimInstance -class Win32_LogicalDisk | Get-Member


<#
Part 5: Then start reconstructing the original command
A problem here is that we're sorting by a property that
doesn't exist at that point in the pipeline
#>
Get-CimInstance -class Win32_LogicalDisk |
Select -Property DeviceID,Size |
Sort -Property FreeSpace 


<#
Part 6: We can prove by backing off one command
and using GM
#>
Get-CimInstance -class Win32_LogicalDisk |
Select -Property DeviceID,Size |
Get-Member


# No proceed to Demo 7.1.1B.