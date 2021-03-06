﻿Add-Type -AssemblyName PresentationFramework

$form = New-Object System.Windows.Window

#define what it looks like
$form.Title = "Services Demo"
$form.Height = 400
$form.Width = 500

$stack = New-Object System.Windows.Controls.StackPanel

#create a label
$label = New-Object System.Windows.Controls.Label
$label.HorizontalAlignment = "Left"
$label.Content = "Enter a Computer name:"

#add to the stack
$stack.AddChild($label)

#create a text box
$TextBox = New-Object System.Windows.Controls.TextBox
$TextBox.Width = 110
$TextBox.HorizontalAlignment = "Left"
$TextBox.Text = $env:COMPUTERNAME

#add to the stack
$stack.AddChild($TextBox)

#create a datagrid
$datagrid = New-Object System.Windows.Controls.DataGrid
$datagrid.HorizontalAlignment = "Center"
$datagrid.VerticalAlignment = "Bottom"
$datagrid.Height = 250
$datagrid.Width = 441

$datagrid.CanUserResizeColumns = "True"
$stack.AddChild($datagrid)

#create a button
$btn = New-Object System.Windows.Controls.Button
$btn.Content = "_OK"
$btn.Width = 75
$btn.HorizontalAlignment = "Center"

#this will now work
$OK = {
    Write-Host "Getting services from $($textbox.Text)" -ForegroundColor Green
    $data = Get-Service -ComputerName $textbox.Text |
    Select-Object -Property Name, Status, Displayname
    $datagrid.ItemsSource = $data
}

#add an event handler
$btn.Add_click($OK)

#add to the stack
$stack.AddChild($btn)

#add the stack to the form
$form.AddChild($stack)

#run the OK scriptblock when form is loaded
$form.Add_Loaded($OK)

$btnQuit = New-Object System.Windows.Controls.Button
$btnQuit.Content = "_Quit"
$btnQuit.Width = 75
$btnQuit.HorizontalAlignment = "center"

#add the quit button to the stack
$stack.AddChild($btnQuit)

#close the form
$btnQuit.add_click({$form.Close()})

#show the form and suppress the boolean output
[void]($form.ShowDialog()) a   b u t t o n  
 $ b t n   =   N e w - O b j e c t   S y s t e m . W i n d o w s . C o n t r o l s . B u t t o n  
 $ b t n . C o n t e n t   =   " _ O K "  
 $ b t n . W i d t h   =   7 5  
 $ b t n . H o r i z o n t a l A l i g n m e n t   =   " C e n t e r "  
  
 # t h i s   w i l l   n o w   w o r k  
 $ O K   =   {  
         W r i t e - H o s t   " G e t t i n g   s e r v i c e s   f r o m   $ ( $ t e x t b o x . T e x t ) "   - F o r e g r o u n d C o l o r   G r e e n  
         $ d a t a   =   G e t - S e r v i c e   - C o m p u t e r N a m e   $ t e x t b o x . T e x t   |  
         S e l e c t - O b j e c t   - P r o p e r t y   N a m e ,   S t a t u s ,   D i s p l a y n a m e  
         $ d a t a g r i d . I t e m s S o u r c e   =   $ d a t a  
 }  
  
 # a d d   a n   e v e n t   h a n d l e r  
 $ b t n . A d d _ c l i c k ( $ O K )  
  
 # a d d   t o   t h e   s t a c k  
 $ s t a c k . A d d C h i l d ( $ b t n )  
  
 # a d d   t h e   s t a c k   t o   t h e   f o r m  
 $ f o r m . A d d C h i l d ( $ s t a c k )  
  
 # r u n   t h e   O K   s c r i p t b l o c k   w h e n   f o r m   i s   l o a d e d  
 $ f o r m . A d d _ L o a d e d ( $ O K )  
  
 $ b t n Q u i t   =   N e w - O b j e c t   S y s t e m . W i n d o w s . C o n t r o l s . B u t t o n  
 $ b t n Q u i t . C o n t e n t   =   " _ Q u i t "  
 $ b t n Q u i t . W i d t h   =   7 5  
 $ b t n Q u i t . H o r i z o n t a l A l i g n m e n t   =   " c e n t e r "  
  
 # a d d   t h e   q u i t   b u t t o n   t o   t h e   s t a c k  
 $ s t a c k . A d d C h i l d ( $ b t n Q u i t )  
  
 # c l o s e   t h e   f o r m  
 $ b t n Q u i t . a d d _ c l i c k ( { $ f o r m . C l o s e ( ) } )  
  
 # s h o w   t h e   f o r m   a n d   s u p p r e s s   t h e   b o o l e a n   o u t p u t  
 [ v o i d ] ( $ f o r m . S h o w D i a l o g ( ) ) 