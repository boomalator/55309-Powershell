#requires -version 5.0

<#
JSON Processing script for Toolmaking book

Process the directory of JSON files and create a summary report in the
form of an object with these properties:

    Number of files processed
    Total number of items processed
    Average number of items processed
    Total number of Errors
    Average number of Errors
    Total number of Warnings
    Average number of Warnings
    StartDate (the earliest run date value)
    EndDate (the last run date value)

#>

[cmdletbinding()]
Param(
    [Parameter(
        Position = 0,
        Mandatory,
        HelpMessage = "Enter the path with the json test data"
    )]
    [ValidateNotNullorEmpty()]
    [string]$Path
)

Write-Verbose "Starting $($MyInvocation.MyCommand)"

Write-Verbose "Processing files from $Path"

$files = Get-ChildItem -Path $path -Filter *.dat

Write-Verbose "Found $($files.count) files."
$data = foreach ($file in $files) {
    Write-Verbose "Converting $($file.name)"
    Get-Content -Path $file.fullname |
    ConvertFrom-Json |
    Select-Object -Property Errors,Warnings,
    @{Name = "Date"; Expression = {$_.RunDate -as [datetime]}},
    @{Name = "ItemCount"; Expression = {$_.'Items processed'}}
}

#sort the data to get the first and last dates
$sorted = $data | Sort-Object Date
$first = $sorted[0].Date
$last = $sorted[-1].Date

Write-Verbose "Measuring data"
# The $stats variable will be an array of measurements for each property
$stats = $data | Measure-Object errors, warnings, ItemCount -sum -average

Write-Verbose "Creating summary result"
[PSCustomObject]@{
    NumberFiles           = $data.count
    TotalItemsProcessed   = $stats[2].sum
    AverageItemsProcessed = $stats[2].Average
    TotalErrors           = $stats[0].sum
    AverageErrors         = $stats[0].average
    TotalWarnings         = $stats[1].sum
    AverageWarnings       = $stats[1].Average
    StartDate             = $first
    EndDate               = $last
}

Write-Verbose "Ending $($MyInvocation.MyCommand)"