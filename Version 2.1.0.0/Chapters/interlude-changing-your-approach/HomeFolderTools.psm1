function Get-FolderSize {
[CmdletBinding()]
Param(
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName
    )]
    [string[]]$Path
)
BEGIN {}
PROCESS {
    ForEach ($folder in $path) {
        Write-Verbose "Checking $folder"
        if (Test-Path -Path $folder) {
            Write-Verbose " + Path exists"
            
            #turn the folder into a true FileSystem path
            $cPath = Convert-Path $Folder

            $params = @{
                Path    = $cPath
                Recurse = $true
                File    = $true
            }
            $measure = Get-ChildItem @params |
            Measure-Object -Property Length -Sum
            [pscustomobject]@{
                Path  = $cPath
                Files = $measure.count
                Bytes = $measure.sum
            }
        }
        else {
            Write-Verbose " - Path does not exist"
            [pscustomobject]@{
                Path  = $folder
                Files = 0
                Bytes = 0
            }
        } #if folder exists
    } #foreach
} #PROCESS
END {}
} #function

# second function
function Get-UserHomeFolderInfo {
[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$HomeRootPath
)
BEGIN {}
PROCESS {
    Write-Verbose "Enumerating $HomeRootPath"
    $params = @{
        Path      = $HomeRootPath
        Directory = $True
    }
    ForEach ($folder in (Get-ChildItem @params)) {

        Write-Verbose "Checking $($folder.name)"
        $params = @{
            Identity    = $folder.name
            ErrorAction = 'SilentlyContinue'
        }
        $user = Get-ADUser @params

        if ($user) {
            Write-Verbose " + User exists"
            $result = Get-FolderSize -Path $folder.fullname
            [pscustomobject]@{
                User   = $folder.name
                Path   = $folder.fullname
                Files  = $result.files
                Bytes  = $result.bytes
                Status = 'OK'
            }
        }
        else {
            Write-Verbose " - User does not exist"
            [pscustomobject]@{
                User   = $folder.name
                Path   = $folder.fullname
                Files  = 0
                Bytes  = 0
                Status = 'Orphan'
            }
            } #if user exists

        } #foreach
    } #PROCESS
    END {}
}
