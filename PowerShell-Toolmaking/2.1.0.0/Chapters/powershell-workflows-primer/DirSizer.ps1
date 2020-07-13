workflow Get-UserFolderSizes {
    Param(
        [string[]]$RootPath
    )

    foreach -parallel ($path in $RootPath) {
        Write-Verbose "Scanning $path"

        # Get subdirectories
        $subs = Get-ChildItem -Path $path -Directory
        Write-Verbose "$($subs.count) user folders"

        foreach -parallel ($sub in $subs) {
            Write-Verbose "Scanning $($sub.FullName)"

            $size = Get-ChildItem -recurse -Path ($sub.FullName) -File |
                    Measure-Object -Property Length -Sum |
                    Select-Object -ExpandProperty Sum

            Write-Verbose "Size of $($sub.FullName) is $size"

            $props = @{Path=$sub.FullName
                       Size=$size}
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj

        } #foreach subdirectory

    } #foreach path
}

Get-UserFolderSizes -RootPath c:\Users