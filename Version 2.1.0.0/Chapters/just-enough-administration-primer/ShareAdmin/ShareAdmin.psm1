Function Get-ShareSize {
[cmdletbinding()]
Param(
[Parameter(
    Position = 0,
    Mandatory,
    ValueFromPipelineByPropertyName
    )]
[string]$Path
)

Begin {
  Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
} #begin

Process {
  Write-Verbose "[PROCESS] Getting share size for $path"

  #use full cmdlet names to avoid problems
  #these commands do not need to be specified in the psrc file
  $stats = Microsoft.PowerShell.Management\Get-Childitem -Path $Path -Recurse `
  -file | Microsoft.PowerShell.Utility\Measure-Object -Property Length -sum

  Microsoft.PowerShell.Utility\New-Object -TypeName PSObject -Property @{
    Path = $path
    FileCount = $stats.count
    FileSize = $stats.sum
  }
}

End {
  Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

}