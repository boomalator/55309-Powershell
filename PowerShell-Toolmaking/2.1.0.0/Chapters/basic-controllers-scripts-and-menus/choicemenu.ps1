#this will give you a graphical menu in the PowerShell ISE.

Function Invoke-Choice {
[CmdletBinding()]
Param()

#a nested function to prompt for the computername
Function promptComputer {
[CmdletBinding()]
Param()

$Computername = Read-Host "Enter a computername or press Enter to use the localhost"
if ($Computername -notmatch "\w+") {
    $computername = $env:COMPUTERNAME
}
#write the result to the pipeline
$Computername

} #promptComputer

#initialize a collection
$coll = @() 

$a = [System.Management.Automation.Host.ChoiceDescription]::new("Running &Services")
$a.HelpMessage = "Get Running Services"
#customize the object and add some PowerShell code to run
$a | Add-Member -MemberType ScriptMethod -Name Invoke -Value {
    $computer = promptComputer
    Get-Service -ComputerName $computer | Where-Object {$_.status -eq "running"}
} -force

#add the item to the collection
$coll+=$a

$b = [System.Management.Automation.Host.ChoiceDescription]::new("Top &Processes")
$b.HelpMessage = "Get top processes sorted by workingset"
$b | Add-Member -MemberType ScriptMethod -Name Invoke -Value {
    $computer = promptComputer
    Get-Process -ComputerName $computer | 
    Sort-Object -property WS -Descending | 
    Select-Object -first 10} -force
$coll+=$b

$c = [System.Management.Automation.Host.ChoiceDescription]::new("&Disk Status")
$c.HelpMessage = "Get fixed disk information"
$c | Add-Member -MemberType ScriptMethod -Name Invoke -Value {
      $params = @{
         ClassName = "win32_logicaldisk"
         ComputerName =  promptComputer
         Filter = "drivetype=3"
       }
      Get-Ciminstance @params
 } -force
$coll+=$c

$q = [System.Management.Automation.Host.ChoiceDescription]::new("&Quit")    
$q.HelpMessage = "Quit and exit"
$coll+=$q

#loop through and keep displaying the menu until the user quits
$running = $true
do {
    $r = $host.ui.PromptForChoice("Help Desk Menu","Select a task:",$coll,3)
    if ($r -lt $coll.count-1) {
        #call the custom method on the selected object
        $coll[$r].invoke() | Out-Host
    } else {
        #quit and bail out
        Write-Host "Have a nice day." -ForegroundColor Green
        $running = $False
    } 
} while ($running) 

}