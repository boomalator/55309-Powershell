Return "This is a snippets file not a script to run."

# to run the demos, you'll need to copy and paste each bit into the correct location.
# or, use the StepX sample code folders and invoke Pester from there

# simple function to test
function Get-FileContents {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]]$Path
    )
    PROCESS {
        foreach ($folder in $path) {

            Write-Verbose "Path is $folder"
            $segments = $folder -split "\\"
            $last = $segments[-1]
            Write-Verbose "Last path is $last"
            $filename = Join-Path $folder $last
            $filename += ".txt"
            Get-Content $filename

        } #foreach folder
    } #process
}



# basic tests file from New-Fixture
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-FileContents" {
    It "does something useful" {
        $true | Should Be $false
    }
}



# step 2
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-FileContents" {

    MkDir TESTDRIVE:\Part1
    MkDir TESTDRIVE\Part1\Part2
    MkDir TESTDRIVE:\Part1\Part3
    "sample" | Out-File TESTDRIVE:\Part1\Part2\Part2.txt
    "sample" | Out-File TESTDRIVE:\Part1\Part3\Part3.txt
    "sample" | Out-File TESTDRIVE:\Part1\Part1.txt


    It "does something useful" {
        $true | Should Be $false
    }
}



# basic test
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-FileContents" {

    MkDir TESTDRIVE:\Part1
    MkDir TESTDRIVE\Part1\Part2
    MkDir TESTDRIVE:\Part1\Part3
    "sample" | Out-File TESTDRIVE:\Part1\Part2\Part2.txt
    "sample" | Out-File TESTDRIVE:\Part1\Part3\Part3.txt
    "sample" | Out-File TESTDRIVE:\Part1\Part1.txt


    It "reads part2.txt" {
        Get-FileContents -Path TESTDRIVE:\Part1\Part2 |
        Should Be "sample"
    }
}



# from within folder...
Invoke-Pester



# expand test...
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-FileContents" {

    MkDir TESTDRIVE:\Part1
    MkDir TESTDRIVE:\Part1\Part2
    MkDir TESTDRIVE:\Part1\Part3
    "sample" | Out-File TESTDRIVE:\Part1\Part2\Part2.txt
    "sample" | Out-File TESTDRIVE:\Part1\Part3\Part3.txt
    "sample" | Out-File TESTDRIVE:\Part1\Part1.txt


    It "reads part2.txt" {
        Get-FileContents -Path TESTDRIVE:\Part1\Part2 |
        Should Be "sample"
    }

    It "reads part3.txt with fwd slashes" {
        Get-FileContents -PATH TESTDRIVE:/Part1/Part3 |
        Should Be "sample"
    }

    It "reads 3 files from the pipeline" {
        $results = "TESTDRIVE:\part1",
        "TESTDRIVE:\part1\part2",
        "TESTDRIVE:\part1\part3" | Get-FileContents
        $results.Count | Should Be 3 
    }
}



# and try it
Invoke-Pester