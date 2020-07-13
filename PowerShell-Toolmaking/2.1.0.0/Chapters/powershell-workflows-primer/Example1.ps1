workflow Example {
    Param(
        [string]$Value
    )

    $procs = Get-Process
    $total_ram = 0
    $services = $null
    $events = $null

    foreach -parallel ($proc in $procs) {
        $workflow:total_ram += $proc.ws
    } #foreach
    Write-Output "Total RAM used $total_ram"

    sequence {

        $folders = Get-ChildItem -Path $value -Directory

        parallel {
            $workflow:services = Get-Service
            $workflow:events = Get-EventLog -LogName Security
        } #parallel

        InLineScript {
            "Hello it is $(Get-Date)"
        } #inline script

        $nics = Get-NetAdapter

    } #sequence

    Write-Output $result
    Write-Output "$($folders.count) folders"
    Write-Output "$($services.count) services"
    Write-Output "$($events.count) events"
    Write-Output "$($nics.count) NICs"

} #workflow

Example -Value "c:\"