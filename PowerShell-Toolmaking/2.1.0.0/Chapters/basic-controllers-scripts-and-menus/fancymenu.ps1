#a fancier function using Write-Host

Function Invoke-MyMenu {

[cmdletbinding()]
Param()

#start with a clear screen
Clear-Host

$title = "Help Desk Menu"
$menuwidth = 30
#calculate how much to pad left to center the title
[int]$pad = ($menuwidth/2)+($title.length/2)

#define a here string for the menu options
$menu = @"

1. Get services
2. Get processes
3. Get System event logs
4. Check free disk space (MB)
5. Quit

"@

Write-Host ($title.PadLeft($pad)) -ForegroundColor Cyan
Write-Host $menu -ForegroundColor Yellow

#Read-Host writes strings but we can specifically treat the result as
#an integer
[int]$r = Read-Host "Select a menu choice"

#validate the value
if ((1..5) -notcontains $r ) {
        write-warning "$r is not a valid choice"
        pause
        Invoke-Mymenu
}
elseif ((1..4) -contains $r) {
    #get computername for first four menu choices
    $Computername = Read-Host "Enter a computername or press Enter to use localhost"
    if ($Computername -notmatch "\w+") {
        $computername = $env:COMPUTERNAME
    }
}

#code to execute
Switch ($r) {
    1 {
        Get-Service -computername $Computername
    }
    2 {
        Get-Process -computername $Computername
    }
    3 {
        Get-Eventlog -LogName System -Newest 25 -ComputerName $Computername
    }
    4 {
       $params = @{
         ClassName = "win32_logicaldisk"
         ComputerName = $Computername
         Filter = "deviceid='c:'"
        }
        $c = Get-CimInstance @params
        $c.FreeSpace/1mb
    }
    5 {
        Write-Host "Have a nice day" -ForegroundColor Green
        #bail out of the command 
        Return
    }
} #switch

#insert a blank line
write-host ""
pause

#run this function again
&$MyInvocation.MyCommand

} #end function 