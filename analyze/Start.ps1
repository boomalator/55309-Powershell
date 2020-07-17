function Query-Disks {
    [cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline, Mandatory)]
    [ValidateNotNullorEmpty()]
    [Alias("CN", "Machine", "Name")]
    [string[]]$Computername,
    [string]$ErrorLog,
    [switch]$ErrorAppend,
    [string]$Password
)

    foreach ($comp in $computername) {
        $logfile = "errors.txt"
          write-host "Trying $comp"
       try {
            gcim win32_logicaldisk -comp $comp -ea stop
      } catch {

        }}
}
