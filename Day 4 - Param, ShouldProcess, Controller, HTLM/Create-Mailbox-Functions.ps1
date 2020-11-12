Function Set-AdminCredential {
    param(
        [String]$UserName="MyCorp\Admin2",
        [String]$FilePath=""
    )

    $CredsToSave = Get-Credential -Credential $UserName
    $fileSpec = "$FilePath$($UserName.Replace("\", "-")).xml"
    $CredsToSave |  Export-Clixml -Path $fileSpec
}

Function Get-AdminCredential {
    param(
        [String]$UserName="MyCorp\Admin2",
        [String]$FilePath=""
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

Function Test-Command ($Command) {
    Try
    {
        Get-command $command -ErrorAction Stop
        Return $True
    }
    Catch [System.SystemException]
    {
        Return $False
    }
}

Function Out-ExecutionMetaData {
    [CmdletBinding()]
    Param()

    Write-Verbose "Execution Metadata:"
    Write-Verbose "User = $($env:userdomain)\$($env:USERNAME)"
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $IsAdmin = [System.Security.Principal.WindowsPrincipal]::new($id).IsInRole('administrators')
    Write-Verbose "Is Admin = $IsAdmin"
    Write-Verbose "Computername = $env:COMPUTERNAME"
    Write-Verbose "OS = $((Get-CimInstance Win32_Operatingsystem).Caption)"
    Write-Verbose "Host = $($host.Name)"
    Write-Verbose "PSVersion = $($PSVersionTable.PSVersion)"
    Write-Verbose "Runtime = $(Get-Date)"
}

Function Initialize-EmsCommands {
    Param(
        [PScredential]$Credential = (Get-AdminCredential)
    )
    if (Test-Command "Get-Mailbox") {
        Write-Host "Exchange cmdlets already present."
    } else {
        Write-Host "Loading exchange cmdlets."
        $CallEMS = ". '$env:ExchangeInstallPath\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell -Credential $Credential "
        Invoke-Expression $CallEMS
    }
}

Function New-OrgPassword {
    Param (
        [ValidateSet("MC","OC", "CH", "LU", "X")]
        [String]$Organization = "MC"
    )
        
    # Create a password from Org, Month, day, milliseconds
    $pw = (Get-Date).ToString("MMddfff")
    $pw = "$Organization $pw"
    Write-Output $pw
    # This delay prevents multiple passwords being the same, even if called quickly
    Start-Sleep -Milliseconds 11
}

Function New-OrgOptions {
    Param (
        [ValidateSet("MC","OC", "CH", "LU", "X")]
        [String]$Organization = "MC"
    )

    Switch ($Organization) {
        "MC"    {
                    $upns = "MyCorp.com" 
                    $disps = ""
                    $db = "MC-2-USERS-2019"
                }
        "OC"   {
                    $upns = "OtherOrg.club" 
                    $disps = " (Other Org Club)"
                    $db = "MC-2-USERS-2019"
                }
        "LU"    {
                    $upns = "BusinessGroupLimited.ca" 
                    $disps = " (Business Group Limited)"
                    $db = "MC-2-USERS-2019"
                }
        "CH"    {
                    $upns = "BrandedCo.ca" 
                    $disps = " (BrandedCo)"
                    $db = "MC-2-USERS-2019"
                }
        default: {}
    }

    $props = @{
                "upnSuffix"=$upns
                "DisplaySuffix"=$disps
                "ExDataBase"=$db
            }
    $obj = New-Object -TypeName PSObject -Property $props
    Write-Output $obj

}

Function Set-SimpleDisplayName {
    Param(
        [String]$alias,
        [String]$SimpleDisplayName
    )

    if ($alias.Length -lt 1) {return}
    $dcname = $env:LOGONSERVER.Replace('\\','')
    $dc=Get-ADDomainController -Identity $dcname
    $AdminCreds = Get-AdminCredential

    try {
        Set-User $alias -SimpleDisplayName $SimpleDisplayName
        Write-Host "Set $alias to a SDN of $SimpleDisplayName" -ForegroundColor Cyan
    } catch {
        Write-Host "An error occurred setting the Simple Display Name."
    }
}

Function Add-SmtpAddress {
    Param(
        [String]$Mailbox,
        [String]$NewSmtpAddress
    )

    try { 
        Set-Mailbox $Mailbox -EmailAddresses @{add=$NewSmtpAddress} -ErrorAction stop -Confirm:$false
    } catch {
        Write-Warning "Failed to set new SMTP Addresss. $Errror[0].Message"
    }

}

Function Add-ReadAllDelegate {
    Param(
        [String]$Mailbox,
        [String]$Delegate
    )
    try {
        $DelegateMbx = Get-Mailbox $UserStr -ErrorAction stop
    } catch {
        Write-Warning "Failed to get Delegate mailbox. $(($Error[0]).Message)"
        Return
    }
    try {
        Remove-MailboxPermission $Mailbox -User $Delegate -AccessRights FullAccess -InheritanceType All -ErrorAction stop -Confirm:$false
        Start-Sleep -Seconds 3
        Add-MailboxPermission $Mailbox -User $Delegate -AccessRights FullAccess -AutoMapping $false -ErrorAction stop 
        Start-Sleep -Milliseconds 500
    } catch {
        Write-Warning "Failed to set new Delegate. $(($Error[0]).Message)"
    }
}

Function Add-SendAsDelegate {
    Param(
        [String]$Mailbox,
        [String]$Delegate
    )

    try {
        $DelegateMbx = Get-Mailbox $Delegate -ErrorAction stop
        $UserADObj = ( $DelegateMbx.SamAccountName ) | Get-ADuser -ErrorAction stop 
    } catch {
        Write-Warning "Failed to get Delegate mailbox or AD Object. $(($Error[0]).Message)"
        Return
    }

    try {
        $TargetMbx = Get-Mailbox $Mailbox -ErrorAction stop
    } catch {
        Write-Warning "Failed to get target mailbox. $(($Error[0]).Message)"
        Return
    }

    try {
        Remove-ADPermission $TargetMbx.Identity -User $(($UserADObj).UserPrincipalName) -AccessRights ExtendedRight -ExtendedRights "Send As" -ErrorAction stop -Confirm:$false
        Start-Sleep -Seconds 3
        Add-ADPermission $TargetMbx.Identity -User $UserADObj.UserPrincipalName -AccessRights ExtendedRight -ExtendedRights "Send As" -ErrorAction stop 
        Start-Sleep -Milliseconds 500
    } catch {
        Write-Warning "Failed to set new Delegate. $(($Error[0]).Message)"
    }
}

Function New-OrgMailbox {
   Param (
        [ValidateSet("MC","OC", "CH", "LU", "X")]
        [String]$Organization = "MC",
        [String]$FirstName,
        [String]$LastName,
        [String]$FullName,
        [String]$NewPassword,
        [String]$SamDomain =  "",
        [Bool]$shared = $false
    ) 

    if (($FullName.Length -lt 1) -and ($FirstName.Length -lt 1) -and ($LastName.Length -lt 1)) {
        Write-Warning "Cannot continue without a name. Sorry."
        Return
    }

    if ($FullName.Length -lt 1) {
        $FullName = "$FirstName $LastName"
    }

    if ($NewPassword.Length -lt 1) {
        $NewPassword = New-OrgPassword -Organization $Organization
    }

    $exOptions = New-OrgOptions -Organization $Organization

    if (($FirstName.Length -ge 1) -and ($LastName.Length -ge 1)) {
        $mailPrefix = "$firstname.$lastname"
    } else {
        $mailPrefix = $FullName
    }

    $upn = "$mailPrefix@$($exOptions.upnSuffix)"
    $disp = "$FullName$($exOptions.DisplaySuffix)"
    $alias = "$FullName.$Organization".Replace(" ",".")
    $alias = "$alias".Replace(".MC","")
    
    $domainAlias = "$SamDomain\$alias"
    $dcname = $env:LOGONSERVER.Replace('\\','')
    $dc=Get-ADDomainController -Identity $dcname
    
    Write-Host "New Email: $upn"  -ForegroundColor Cyan
    Write-Host "Password: $NewPassword" -ForegroundColor Cyan
    
    New-Mailbox `
        -Name $fullname `
        -UserPrincipalName $upn `
        -Password (ConvertTo-SecureString -String $newPassword -AsPlainText -Force) `
        -FirstName $FirstName `
        -LastName $LastName `
        -Database $exOptions.exDatabase `
        -Alias $alias `
        -DisplayName $disp `
        -PrimarySmtpAddress $upn `
        -SamAccountName $alias `
        -DomainController $dc.HostName `
         -WhatIf

    if ($shared) {
        Start-Sleep -Seconds 2
        Set-Mailbox -Identity $upn -type Shared #-WhatIf
    }
cls
    Start-Sleep -Seconds 2
    Set-SimpleDisplayName -alias $alias -SimpleDisplayName $FullName

}

$AdminCred = Get-AdminCredential
Initialize-EmsCommands

#  New-OrgMailbox -FullName "John Smithson" -Organization MC # -shared $true

