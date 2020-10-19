Function Get-XXSystemInfo {
[CmdletBinding()]
param(
    [Parameter(
        Mandatory,
        ValueFromPipeline
    )]
    [string[]]$Computername,

    [Parameter()]
    [ValidateSet('Dcom', 'Wsman')]
    [string]$Protocol = 'Wsman',

    [Parameter()]
    [switch]$TryOtherProtocol
)
BEGIN {
    If ($Protocol -eq 'Dcom') {
        $cso = New-CimSessionOption -Protocol Dcom
    }
    else {
        $cso = New-CimSessionOption -Protocol Wsman
    }
}
PROCESS {
    ForEach ($comp in $computername) {
        Try {
        Write-Verbose "Attempting $comp on $protocol"
        $s = New-CimSession -ComputerName $comp -SessionOption $cso -EA Stop

        Write-Verbose "  [+] Connected"
        $os = Get-CimInstance -CimSession $s -ClassName Win32_OperatingSystem
        $bios = Get-CimInstance -CimSession $s -ClassName Win32_BIOS
        $props = @{
            ComputerName = $comp
            BIOSSerial   = $bios.serialnumber
            OSVersion    = $os.version
        }
        New-Object -TypeName PSObject -Property $props
        }
        Catch {
            Write-Warning "Skipping $comp due to failure to connect"
            if ($TryOtherProtocol) {
                If ($Protocol -eq 'Dcom') {
                    Get-XXSystemInfo -Protocol Wsman -Computername $comp
                }
                else {
                    Get-XXSystemInfo -Protocol Dcom -Computername $comp
                }
            }
        } #Catch
    } #ForEach
} #PROCESS
END {}
}