function Set-ServiceStatus {
    [CmdletBinding()]
    Param(
        [string[]]$ServiceName
    )
    foreach ($name in $ServiceName) {

        $svc = Get-Service $name -EA SilentlyContinue
        if ($svc) {
            if ($svc.Status -ne 'Running') {
                $svc | Start-Service
            }
            $svc | Get-Service
        }

    } #foreach
}

Set-ServiceStatus bits