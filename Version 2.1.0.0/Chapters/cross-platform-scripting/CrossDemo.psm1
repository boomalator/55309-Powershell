#Windows commands
Function Export-Data {
    [cmdletbinding()]
    Param(
    [ValidateScript({Test-Path $_})]
    [string]$Path = "."
    )

    $time = Get-Date -format FileDate
    $file = "$($time)_export.json"
    $ExportPath = Join-Path -Path (Convert-Path $Path) -ChildPath $file
    Write-Verbose "Exporting data to $exportPath"

    # code ...
}

Function Get-DiskFree {
    [cmdletbinding()]
    [alias("df")]
    Param(
        [ValidateNotNullorEmpty()]
        [string]$Path = "c:",
        [ValidateNotNullorEmpty()]
        [string]$Computername = $env:computername,
        [ValidateSet("Bytes", "KB", "MB", "GB")]
        [string]$As = "bytes"
    )

    if ($IsWindows -OR $PSEdition -eq 'desktop') {
        $Drive = (Get-Item $Path).Root -replace "\\"
        Write-Verbose "Getting disk information for $drive in $As"
        $param = @{
         ClassName = "win32_logicaldisk"
         filter = "deviceid = '$drive'" 
         Property = "Freespace"
         ComputerName = $computername
        }

        $data = Get-Ciminstance @param

        Switch ($As) {
            "KB" { $data.FreeSpace / 1KB}
            "MB" { $data.FreeSpace / 1MB}
            "GB" { $data.FreeSpace / 1GB}
            Default { $data.FreeSpace }
        }
    } #if Windows
    else {
        Write-Warning 'This command requires a Windows platform.'
    }
}

#PS 7 commands
Function Get-RemoteData {
    [cmdletbinding(DefaultParameterSetName = "computer")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "computer"
        )]
        [Alias("cn")]
        [string[]]$Computername,
        [Parameter(ParameterSetName = "computer")]
        [alias("runas")]
        [pscredential]$Credential,
        [Parameter(ValueFromPipeline,ParameterSetName = "session")]
        [System.Management.Automation.Runspaces.PSSession]$Session
    )
    Begin {
      $sb = {"Getting remote data from $([environment]::MachineName) [$PSEdition]"}
      $PSBoundParameters.Add("Scriptblock",$sb)
    }
    Process {
      Invoke-Command @PSBoundParameters
    }
    End {}
}

Function Get-Status {
    [cmdletbinding(DefaultParameterSetName = 'name')]
    [alias("gst")]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the name of a computer',
            ParameterSetName = 'name')
        ]
        [ValidateNotNullOrEmpty()]
        [string]$Computername = $env:computername,
        [Parameter(ParameterSetName = 'name')]
        [pscredential]$Credential,
        [Parameter(ParameterSetName = 'Session', ValueFromPipeline)]
        [CimSession]$Cimsession,
        [switch]$AsString
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using parameter set $($pscmdlet.ParameterSetName)"
        $sessParams = @{
            ErrorAction  = 'stop'
            computername = $null
        }
        $cimParams = @{
            ErrorAction = 'stop'
            classname   = $null
        }

        if ($pscmdlet.ParameterSetName -eq 'name') {
            #create a temporary Cimsession
            $sessParams.Computername = $Computername
            if ($Credential) {
                $sessParams.Credential = $credential
            }

            Try {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating temporary cimsession to $computername"
                $Cimsession = New-CimSession @sessParams
                $tempsession = $True
            }
            catch {
                Write-Error $_
                #bail out
                return
            }
        }

        if ($Cimsession) {

            $hash = [ordered]@{
                Computername = $cimsession.computername.toUpper()
            }
            Try {
                $cimParams.classname = 'Win32_OperatingSystem'
                $cimParams.CimSession = $Cimsession
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Querying $($cimparams.classname)"
                $OS = Get-CimInstance @cimParams
                $uptime = (Get-Date) - $OS.lastBootUpTime
                $hash.Add("Uptime", $uptime)

                $pctFreeMem = [math]::Round(($os.FreePhysicalMemory / $os.TotalVisibleMemorySize) * 100, 2)
                $hash.Add("PctFreeMem", $pctFreeMem)

                $cimParams.classname = 'Win32_Logicaldisk'
                $cimParams.filter = "drivetype=3"

                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Querying $($cimparams.classname)"
                Get-CimInstance @cimParams | ForEach-Object {
                    $name = "PctFree{0}" -f $_.deviceid.substring(0, 1)
                    $pctFree = [math]::Round(($_.FreeSpace / $_.size) * 100, 2)
                    $hash.add($name, $pctfree)
                }

                $status = New-Object PSObject -Property $hash

                if ($AsString) {
                    $upstring = $uptime.toString().substring(0, $uptime.toString().LastIndexOf("."))
                    #colorize if running in PowerShell 7
                    if ($IsWindows -AND $IsCoreCLR) {
                        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Formatting for PowerShell 7.x"
                        #strip the milliseconds off the uptime
                        $string = "`e[38;5;47m{0}`e[0m Up:{1}" -f $status.computername,$upstring
                    }
                    Else {
                        $string = "{0} Up:{1}" -f $status.computername, $upstring
                    }

                    #Get free properties
                    $free = $status.psobject.properties | Where-Object Name -match PctFree

                    foreach ($item in $free) {
                        $sName = $item.name -replace "Pct", "%"
                        if ($IsWindows -AND $IsCoreCLR) {
                            #Colorize values
                            if ([double]$item.value -le 20) {
                                #red
                                $value = "`e[91m$($item.value)`e[0m"
                            }
                            elseif ([double]$item.value -le 50) {
                                #yellow
                                $value = "`e[93m$($item.value)`e[0m"
                            }
                            else {
                                #green
                                $value = "`e[92m$($item.value)`e[0m"
                            }
                        }
                        else {
                            $value = $item.Value
                        }

                        $string += " {0}:{1}" -f $sname, $value

                    } #foreach item in free

                    $string
                }
                else {
                    $status
                }
            }
            catch {
                Write-Error $_
            }

            #only remove the cimsession if it was created in this function
            if ($tempsession) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Removing temporary cimsession"
                Remove-CimSession -CimSession $Cimsession
            }
        } #if cimsession
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
} #close function
