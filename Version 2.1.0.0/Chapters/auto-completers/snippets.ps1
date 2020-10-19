return "This is a snippets file"

Function Get-Foo {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0)]
        [ValidateSet("This","That","Other","Squirrel")]
        [string]$Item = "This"
    )
   
   Write-Host "Working with $item" -ForegroundColor green
}

Function Get-ProcessDetail {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [ArgumentCompleter({(Get-Process).name})]
        [string]$Name
    )

    Get-Process -Name $Name | 
    Select-Object -property ID, Name, StartTime, WorkingSet, 
    @{Name = "Path" ; Expression = {$_.MainModule.FileName}},
    @{Name = "RunTime"; Expression = {(Get-Date) - $_.starttime}}
}

Get-Command Register-ArgumentCompleter
help Register-ArgumentCompleter

#add completion to a command
#new(completion text,listitem text,result type,Tooltip)
$sb = {
 param(
  $commandName, 
  $parameterName, 
  $wordToComplete, 
  $commandAst, 
  $fakeBoundParameter
  )

 (Get-WinEvent -listlog "$wordtoComplete*").logname | 
  ForEach-Object {   
  [System.Management.Automation.CompletionResult]::new($_,$_,'ParameterValue',$_)
 }
}

$params = @{
 CommandName = "Get-WinEvent"
 ParameterName = "Logname"
 ScriptBlock  = $sb
}
Register-ArgumentCompleter @params

# Get-WinEvent -Logname <tab>

Function Measure-Folder {
[cmdletbinding()]
Param(
[Parameter(Position = 0,HelpMessage = "Specify the folder path to measure")]
[string]$Name = "."
)

Get-ChildItem -path $Name -Recurse -File | 
Measure-Object -Property length -sum -Average |
Select-Object @{Name="Path";Expression={Convert-Path $Name}},
Count,Sum,Average

}

#define for a function
$sb = {
 param(
  $commandName, 
  $parameterName, 
  $wordToComplete, 
  $commandAst, 
  $fakeBoundParameter
)
 Get-Childitem -path . -Directory | 
 ForEach-Object {
  [System.Management.Automation.CompletionResult]::new($_.fullname,$_.name,
  'ParameterValue',$_.fullname)
 }
 }

$params = @{
 CommandName = "Measure-Folder"
 ParameterName = "Nanme"
 ScriptBlock  = $sb
}
Register-ArgumentCompleter @params
