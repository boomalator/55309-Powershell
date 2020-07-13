Return "This is a snippets file not a script to run."

# notice error behavior
Get-Service -Name BITS, Foo, WinRM

# try each in turn
Get-Service -Name BITS, Foo, WinRM -EA Continue
Get-Service -Name BITS, Foo, WinRM -EA SilentlyContinue
Get-Service -Name BITS, Foo, WinRM -EA Inquire
Get-Service -Name BITS, Foo, WinRM -EA Stop

# moving from this...
foreach ($computer in $Computername) {
    Write-Verbose "Querying $($computer.toUpper())"
    $params = @{
        Classname    = "Win32_OperatingSystem"
        Computername = $computer
    }
    $OS = Get-CimInstance @params


# to this...
foreach ($computer in $Computername) {
    Write-Verbose "Querying $($computer.toUpper())"
    $params = @{
        Classname    = "Win32_OperatingSystem"
        Computername = $computer
        ErrorAction = "Stop"
    }
    $OS = Get-CimInstance @params


#try/catch
foreach ($computer in $Computername) {
     Write-Verbose "Querying $($computer.toUpper())"
     $params = @{
         Classname    = "Win32_OperatingSystem"
         Computername = $computer
         ErrorAction  = "Stop"
     }
     Try {
         $OS = Get-CimInstance @params
         $OK = $True
     }
     Catch {
         $OK = $False
         $msg = "Failed to get system information from $computer. $($_.Exception.Message)"
         Write-Warning $msg
         if ($ErrorLog) {
             Write-Verbose "Logging errors to $ErrorLog. Append = $ErrorAppend"
            "[$(Get-Date)] $msg" | Out-File -FilePath $ErrorLog -Append:$ErrorAppend
         }
     }
     if ($OK) {
        #only continue if successful
         $params.ClassName = "Win32_Processor"
        $cpu = Get-CimInstance @params
        ...
# pseudo-code
Try {
    $ErrorActionPreference = "Stop"
    # run something that doesn't have -ErrorAction
    $ErrorActionPreference = "Continue"
} Catch {
    # ...
}

# pseudo-code
Try {
    # something here generates an exception
} Catch [Exception.Type.One] {
    # deal with that exception here
} Catch [Exception.Type.Two] {
    # deal with the other exception here
} Catch {
    # deal with anything else here
} Finally {
    # run something else
}

