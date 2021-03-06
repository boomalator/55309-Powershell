﻿#Requires -version 5.0

clear-host

$menu = @"
    
 System Information Menu

    1 LogicalDisks 
    2 Services 
    3 Operating system
    4 Computer system
    5 Processes 
    6 Quit

"@

Write-Host $menu -ForegroundColor Yellow

$coll=@()

$item = New-Object System.Management.Automation.Host.ChoiceDescription]::new("&1 Disks")
$item.HelpMessage = "Get logical disk information"
#customize the object and add some PowerShell code to run
$item | Add-Member -MemberType ScriptMethod -Name Invoke -Value {
    Get-CimInstance -ClassName Win32_Logicaldisk -filter "drivetype=3" -ComputerName $computer
} -force

$coll+=$item

$item = New-Object System.Management.Automation.Host.ChoiceDescription]::new("&2 Services")
$item.HelpMessage = "Get service information"
$item | Add-Member -MemberType ScriptMethod -Name Invoke -Value {
    Get-CimInstance -ClassName Win32_service -ComputerName $computer
} -force

$coll+=$item

$item = New-Object System.Management.Automation.Host.ChoiceDescription]::new("&3 OS")
$item.HelpMessage = "Get operating system information"
$item | Add-Member -MemberType ScriptMethod -Name Invoke -Value {
    Get-CimInstance -ClassName win32_operatingsystem -ComputerName $computer |
    Select-Object -Property PSComputername,Caption,Version,InstallDate
} -force

$coll+=$item

$item = new-object System.Management.Automation.Host.ChoiceDescription]::new("&4 Computer")
$item.HelpMessage = "Get computer system information"
$item | Add-Member -MemberType ScriptMethod -Name Invoke -Value {
    Get-CimInstance -ClassName Win32_computersystem -ComputerName $computer | 
    Select Name,Model,Manufacturer,TotalPhysicalmemory
} -force

$coll+=$item

$item = new-object System.Management.Automation.Host.ChoiceDescription]::new("&5 Processes")
$item.HelpMessage = "Get process information"
$item | Add-Member -MemberType ScriptMethod -Name Invoke -Value {
    Get-CimInstance -ClassName Win32_process -ComputerName $computer
} -force

$coll+=$item

$item = new-object System.Management.Automation.Host.ChoiceDescription]::new("&6 Quit")
$item.HelpMessage = "Quit and exit"

$coll+=$item

[int]$r = $host.ui.PromptForChoice("Make a selection:","",$coll,5)

if ($r -eq 5) {
    Write-Host "`nHave a great day.`n" -ForegroundColor green
}
else {
    $computer = Read-Host "`nEnter a computername (leave blank for localhost)"
    if (-Not $computer) {
        #if no computer specified then default to the localhost
        $computer = $env:COMPUTERNAME
    }
    $coll[$r].invoke() | Out-Host

    pause
    #re-run the script
    & $MyInvocation.MyCommand
} 
  
 $ c o l l + = $ i t e m  
  
 $ i t e m   =   n e w - o b j e c t   S y s t e m . M a n a g e m e n t . A u t o m a t i o n . H o s t . C h o i c e D e s c r i p t i o n ] : : n e w ( " & 4   C o m p u t e r " )  
 $ i t e m . H e l p M e s s a g e   =   " G e t   c o m p u t e r   s y s t e m   i n f o r m a t i o n "  
 $ i t e m   |   A d d - M e m b e r   - M e m b e r T y p e   S c r i p t M e t h o d   - N a m e   I n v o k e   - V a l u e   {  
         G e t - C i m I n s t a n c e   - C l a s s N a m e   W i n 3 2 _ c o m p u t e r s y s t e m   - C o m p u t e r N a m e   $ c o m p u t e r   |    
         S e l e c t   N a m e , M o d e l , M a n u f a c t u r e r , T o t a l P h y s i c a l m e m o r y  
 }   - f o r c e  
  
 $ c o l l + = $ i t e m  
  
 $ i t e m   =   n e w - o b j e c t   S y s t e m . M a n a g e m e n t . A u t o m a t i o n . H o s t . C h o i c e D e s c r i p t i o n ] : : n e w ( " & 5   P r o c e s s e s " )  
 $ i t e m . H e l p M e s s a g e   =   " G e t   p r o c e s s   i n f o r m a t i o n "  
 $ i t e m   |   A d d - M e m b e r   - M e m b e r T y p e   S c r i p t M e t h o d   - N a m e   I n v o k e   - V a l u e   {  
         G e t - C i m I n s t a n c e   - C l a s s N a m e   W i n 3 2 _ p r o c e s s   - C o m p u t e r N a m e   $ c o m p u t e r  
 }   - f o r c e  
  
 $ c o l l + = $ i t e m  
  
 $ i t e m   =   n e w - o b j e c t   S y s t e m . M a n a g e m e n t . A u t o m a t i o n . H o s t . C h o i c e D e s c r i p t i o n ] : : n e w ( " & 6   Q u i t " )  
 $ i t e m . H e l p M e s s a g e   =   " Q u i t   a n d   e x i t "  
  
 $ c o l l + = $ i t e m  
  
 [ i n t ] $ r   =   $ h o s t . u i . P r o m p t F o r C h o i c e ( " M a k e   a   s e l e c t i o n : " , " " , $ c o l l , 5 )  
  
 i f   ( $ r   - e q   5 )   {  
         W r i t e - H o s t   " ` n H a v e   a   g r e a t   d a y . ` n "   - F o r e g r o u n d C o l o r   g r e e n  
 }  
 e l s e   {  
         $ c o m p u t e r   =   R e a d - H o s t   " ` n E n t e r   a   c o m p u t e r n a m e   ( l e a v e   b l a n k   f o r   l o c a l h o s t ) "  
         i f   ( - N o t   $ c o m p u t e r )   {  
                 # i f   n o   c o m p u t e r   s p e c i f i e d   t h e n   d e f a u l t   t o   t h e   l o c a l h o s t  
                 $ c o m p u t e r   =   $ e n v : C O M P U T E R N A M E  
         }  
         $ c o l l [ $ r ] . i n v o k e ( )   |   O u t - H o s t  
  
         p a u s e  
         # r e - r u n   t h e   s c r i p t  
         &   $ M y I n v o c a t i o n . M y C o m m a n d  
 } 