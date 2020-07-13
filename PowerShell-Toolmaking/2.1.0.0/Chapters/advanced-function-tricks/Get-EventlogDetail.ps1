Function Get-EventLogDetail {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0)]
        [ArgumentCompleter({(Get-Eventlog -List).log})]
        [string]$LogName
    )
    Write-Verbose "Getting $LogName log details"

    $params = @{
        ClassName = "win32_nteventlogfile"
        filter = "filename='$LogName'" 
        ErrorAction = "Stop"
    }

    Try {
        Get-CimInstance @params |
        Select-Object -Property LogFileName, Name, FileSize, MaxFileSize, 
        LastModified, NumberOfRecords,@{Name="PctUsed";
        Expression={[math]::Round(($_.filesize/$_.maxfilesize)*100,2)}}
    }
    Catch {
        Write-Error $_
    }
}