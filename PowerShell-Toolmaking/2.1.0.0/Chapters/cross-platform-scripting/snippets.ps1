
return "This is a snippets file"

Get-Variable is*

#be careful with this
$file = "$foo\child\file.dat"

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