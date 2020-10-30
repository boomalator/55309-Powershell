<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(400,200)
$Form.text                       = "Test Form"
$Form.TopMost                    = $false

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "button"
$Button1.width                   = 60
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(228,126)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$label1                          = New-Object system.Windows.Forms.Label
$label1.text                     = "This is a label."
$label1.AutoSize                 = $true
$label1.width                    = 25
$label1.height                   = 10
$label1.location                 = New-Object System.Drawing.Point(47,54)
$label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($Button1,$label1))




#Write your logic code here

[void]$Form.ShowDialog()