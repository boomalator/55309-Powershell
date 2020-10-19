function Get-SpecialFolders {
    [CmdletBinding()]
    Param()

    $folders = [enum]::GetNames([System.Environment+SpecialFolder]) 
    Write-Verbose "Got $($folders.count) folders"
    foreach ($folder in $folders) {
     [pscustomobject]@{
        Name = $folder
        Path = [environment]::GetFolderPath($folder)
     }
    }
}
Get-SpecialFolders