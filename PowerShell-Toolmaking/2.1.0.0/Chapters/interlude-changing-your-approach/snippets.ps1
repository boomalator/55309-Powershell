Return "This is a snippets file not a script to run."

# consider this:
$UserNames = Get-ADUser -Filter * -SearchBase "OU=NAME_OF_OU_WITH_USERS3,OU=NAME_OF_OU_WITH_USERS2,OU=NAME_OF_OU_WITH_USERS1,DC=DOMAIN_NAME,DC=COUNTRY_CODE" |
Select-Object -ExpandProperty samaccountname

$UserRegex = ($UserNames | ForEach-Object {[RegEx]::Escape($_)}) -join "|"

$myArray = (Get-ChildItem -Path "\\file2\Felles\Home\*" -Directory | Where-Object {$_.Name -notmatch $UserRegex})

#$myArray

foreach ($mapper in $myArray) {
    #Param ($mapper = $(Throw "no folder name specified"))

    # calculate folder size and recurse as needed
    $size = 0
    Foreach ($file in $(Get-ChildItem $mapper -recurse)) {
        If (-not ($file.psiscontainer)) {
            $size += $file.length
        }
    }

    # return the value and go back to caller
    Write-Output $size
}

# our take (you can run this)
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

