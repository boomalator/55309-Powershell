Return "This is a snippets file not a script to run."

# install module
install-module psscriptanalyzer



# assumes you're in sample code folder
Invoke-ScriptAnalyzer .\Script.ps1



# replace Param() block in script with:
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline, Mandatory)]
    [ValidateNotNullorEmpty()]
    [Alias("CN", "Machine", "Name")]
    [string[]]$Computername,
    [string]$ErrorLog,
    [switch]$ErrorAppend,
    [string]$Password
)



# try again
Invoke-ScriptAnalyzer .\Script.ps1

