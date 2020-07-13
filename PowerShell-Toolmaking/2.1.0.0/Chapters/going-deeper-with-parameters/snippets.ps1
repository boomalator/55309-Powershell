Return "This is a snippets file not a script to run."

# same thing:
Get-Service -Name BITS
Get-Service BITS

# view help
Help get-service

# quick example
function test {
    param(
        [string[]]$one,
        [int]$two,
        [switch]$three
    )
}

help test -Full

# assigned positions
function test {
    param(
        [Parameter(Position=1)]
        [string[]]$one,

        [Parameter(Position=2)]
        [int]$two,

        [Parameter(Position=3)]
        [switch]$three
    )
}

help test -Full

# assign to parameter set
[Parameter(ParameterSetName="query")]
[string]$query

# membership in multiple sets
[Parameter(ParameterSetName="one")]
[Parameter(ParameterSetName="two")]
[string]$something


# default parameter set
[CmdletBinding(DefaultParameterSetName="whatever")]


# values from remaining
[Parameter(ValueFromRemainingArguments=$True)]
[string]$Extras

# help message
[Parameter(HelpMessage="Enter a computer name or IP")]
[string[]]$ComputerName


# alias
[Alias("cn")]
[string[]]$Computername


# example (complete file is in sample code)
[cmdletbinding(DefaultParameterSetName = "name")]

Param(
[Parameter(Position = 0, Mandatory, 
HelpMessage = "Enter a computer name to check",
ParameterSetName = "name",
ValueFromPipeline)]
[Alias("cn")]
[ValidateNotNullorEmpty()]
[string[]]$Computername,

[Parameter(Mandatory,
HelpMessage = "Enter the path to a text file of computer names",
ParameterSetName = "file"
)]
[ValidateScript({
if (Test-Path $_) {
   $True
}
else {
   Throw "Cannot validate path $_"
}
})]     
[ValidatePattern("\.txt$")]
[string]$Path,

[ValidateRange(10,50)]
[int]$Threshhold = 25,

[ValidateSet("C:","D:","E:","F:")]
[string]$Drive = "C:",

[switch]$Test
)


# example of path validation
[ValidateScript({Test-Path $_)}
