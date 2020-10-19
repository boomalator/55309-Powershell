<#
#include directly in the script file
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Disk Report" Height="355" Width="535" Background="#FFBDB3B3">
    <Grid>
        <Button x:Name="btnRun" Content="_Run" HorizontalAlignment="Left"
        Height="20" Margin="343,291,0,0" VerticalAlignment="Top" Width="74"/>
        <Button x:Name="btnQuit" Content="_Quit" HorizontalAlignment="Left"
        Margin="433,291,0,0" VerticalAlignment="Top" Width="75"
        RenderTransformOrigin="0.365,-0.38"/>
        <ComboBox x:Name="comboNames" HorizontalAlignment="Left" Height="20"
        Margin="11,25,0,0" VerticalAlignment="Top" Width="166"/>
        <Label x:Name="label" Content="Select a computer"
        HorizontalAlignment="Left" Height="27" Margin="9,3,0,0"
        VerticalAlignment="Top" Width="206"/>
        <DataGrid x:Name="dataGrid" HorizontalAlignment="Left"
        Height="229" Margin="10,55,0,0" VerticalAlignment="Top" Width="498"/>
    </Grid>
</Window>
"@
#>

Add-Type -AssemblyName PresentationFramework

#or read it in separately
[xml]$xaml = Get-Content $psscriptroot\diskstat.xaml

$reader = New-Object system.xml.xmlnodereader $xaml
$form = [windows.markup.xamlreader]::Load($reader)

#find the controls
$grid = $form.FindName("dataGrid")
$run = $form.FindName("btnRun")
$quit = $form.Findname("btnQuit")
$drop = $form.FindName("comboNames")

$run.Add_Click({

#uncomment for testing
#write-host $drop.Text

$grid.clear()

#or call your external command
$data = @(Get-CimInstance -class win32_logicaldisk -filter "drivetype=3" -ComputerName $drop.Text |
Select-Object -property @{Name="Computername";Expression={$_.SystemName}},
DeviceID,@{Name="SizeGB";Expression={$_.Size/1GB -as [int]}},
@{Name="FreeGB";Expression = { [math]::Round($_.Freespace/1GB,2)}},
@{Name="PctFree";Expression = { ($_.freespace/$_.size)*100 -as [int]}})

#uncomment for testing
#$data | out-string | write-host

$grid.ItemsSource = $data

}
)

$quit.Add_Click({$form.Close()})

#make the box editable so a user can enter another name
$drop.IsEditable = $True

#read in content from a text file
# $names = get-content .\computers.txt

#hard coded demo names
$names = $env:computername,"localhost"

$names | foreach {
 $drop.Items.Add($_) | Out-Null
}

#give combo box focus
$drop.focus()

$form.ShowDialog() | Out-Null