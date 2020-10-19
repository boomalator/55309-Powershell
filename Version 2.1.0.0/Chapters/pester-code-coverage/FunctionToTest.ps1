function Get-MyServer {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Computername,
        [switch]$ResolveIP,
        [switch]$UseDcom,
        [pscredential]$Credential
    )

    Begin {
        Write-Verbose "Starting $($myinvocation.MyCommand)"
        $params = @{
            SkipTestConnection = $True
        }
    }
    Process {
        if ($UseDcom) {
            Write-Verbose "Connecting with DCOM"
            $opt = New-CimSessionOption -Protocol Dcom
            $params.Add("SessionOption", $opt)
        }
   
        if ($Credential) {
            Write-Verbose "Using alternate credential"
            $params.Credential = $Credential
        }
    
        if ($ResolveIP) {
            Write-Verbose "Resolving IP4 address"
            $resolve = @{
             Name = $Computername 
             Type = "A"
             TcpOnly = $True 
             ErrorAction = "SilentlyContinue"
            }
            $IP = (Resolve-DnsName @resolve).ip4Address
        }
        else {
            $IP = "0.0.0.0"
        }
        $cs = New-Cimsession @params
        $compsys = $cs | Get-CimInstance -classname win32_computersystem
        $os = $cs | Get-CimInstance -ClassName win32_operatingsystem
        $proc = $cs | 
        Get-CimInstance -ClassName win32_processor | 
        Select-Object -Property Name -first 1

        [pscustomobject]@{
            Computername = $compsys.Name
            IP           = $IP
            TotalMemGB   = $compsys.TotalPhysicalMemory / 1GB -as [int]
            Model        = $compsys.model
            OS           = $os.Caption
            Build        = $os.BuildNumber
            Processor    = $proc.Name
        }

        Remove-CimSession $cs
    }
    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}