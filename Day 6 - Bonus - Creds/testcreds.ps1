Function Get-AdminCredential {
    param(
        [String]$UserName='HQ\Speck',
        [String]$FilePath='c:\scripts\'
        )

    $fileSpec = "$FilePath$($UserName.Replace("\", "-")).xml"
    try {
        Write-Output (Import-Clixml $fileSpec)
    } catch {
        Write-Warning "Could not read saved credentials"
        Set-AdminCredential -UserName $UserName -FilePath $FilePath
        Write-Output (Import-Clixml $fileSpec)
    }      
} 

Function Set-AdminCredential {
    param(
        [String]$UserName='HQ\Speck',
        [String]$FilePath='c:\scripts\'
        )

    $CredsToSave = Get-Credential -Credential $UserName
    $fileSpec = "$FilePath$($UserName.Replace("\", "-")).xml"
    $CredsToSave |  Export-Clixml -Path $fileSpec
}

$SuperUser = Get-AdminCredential

# Use -credentials parameter on any cmdlet that supports it:

Remove-ADUser -Identity Geneway -Credential $SuperUser -Confirm:$false 
New-ADUser -SamAccountName Geneway -Name Geneway -Credential $SuperUser

# Run a file (may or may not be PS, [almost] any executable )
Start-process powershell.exe -credential ($SuperUser)  -NoNewWindow `
    -ArgumentList '-executionpolicy bypass', '-file','C:\scripts\remove-text.ps1' -WorkingDirectory c:\scripts

# Run a PS Script File -- note, run on the computer hosting the resources unless you set up delegation
# works
Invoke-Command -Credential $SuperUser -ComputerName Alpha -FilePath C:\scripts\remove-test.ps1 

# fails unless you set up delegation, 
# Invoke-Command -Credential $SuperUser -ComputerName Echo -FilePath C:\scripts\remove-test.ps1 

# Just Invoke the Command (without a file) as a scriptblock -- note, run on the computer hosting the resources unless you set up delegation

$cmd = { $filename = '\\alpha\LabFiles\test\test2.txt';  if (Test-Path $filename) { Remove-Item $filename } ; New-Item $filename }

# works
Invoke-Command -Credential $SuperUser -ScriptBlock $cmd -ComputerName Alpha

# fails unless you set up delegation, 
# see https://docs.microsoft.com/en-us/archive/blogs/ashleymcglone/powershell-remoting-kerberos-double-hop-solved-securely
# Invoke-Command -Credential $SuperUser -ScriptBlock $cmd -ComputerName Echo
