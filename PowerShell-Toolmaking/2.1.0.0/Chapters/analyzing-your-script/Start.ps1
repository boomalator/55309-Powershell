function Query-Disks {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory)]
        [string[]]$ComputerName = 'localhost'
    )
    foreach ($comp in $computername) {
        $logfile = "errors.txt"
          write-host "Trying $comp"
       try {
            gcim win32_logicaldisk -comp $comp -ea stop
      } catch {

        }}
}