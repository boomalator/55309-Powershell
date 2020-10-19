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
}
