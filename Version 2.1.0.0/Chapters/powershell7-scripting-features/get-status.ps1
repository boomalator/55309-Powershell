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
    #not used
} #begin

Process {
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
            $OS = Get-CimInstance @cimParams
            $uptime = (Get-Date) - $OS.lastBootUpTime
            $hash.Add("Uptime", $uptime)

            $pctFreeMem = [math]::Round(($os.FreePhysicalMemory / 
            $os.TotalVisibleMemorySize) * 100, 2)
            $hash.Add("PctFreeMem", $pctFreeMem)

            $cimParams.classname = 'Win32_Logicaldisk'
            $cimParams.filter = "drivetype=3"
                        
            Get-CimInstance @cimParams | ForEach-Object {
                $name = "PctFree{0}" -f $_.deviceid.substring(0, 1)
                $pctFree = [math]::Round(($_.FreeSpace / $_.size) * 100, 2)
                $hash.add($name, $pctfree)
            }

            $status = New-Object PSObject -Property $hash

            if ($AsString) {
                $upstring = $uptime.toString().substring(0,
                $uptime.toString().LastIndexOf("."))
                #colorize if running in PowerShell 7
                if ($IsWindows -AND $IsCoreCLR) {
                  #strip the milliseconds off the uptime
                  $string = "`e[38;5;47m{0}`e[0m Up:{1}" -f $status.computername,
                  $upstring
                }
                Else {
                    $string = "{0} Up:{1}" -f $status.computername, $upstring
                }

                #Get free properties
                $free = $status.psobject.properties | 
                Where-Object Name -match PctFree

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
            Remove-CimSession -CimSession $Cimsession
        }
    } #if cimsession
} #process

End {
    Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
} #end
} #close function
