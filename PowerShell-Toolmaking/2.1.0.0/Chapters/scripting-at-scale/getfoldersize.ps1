Function Get-FolderSize {
    [cmdletbinding()]
    Param(
        [Parameter(
            Position = 0, 
            ValueFromPipeline, 
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullorEmpty()]
        [string]$Path = $env:temp
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin

    Process {
        Write-Verbose "[PROCESS] Analyzing: $path"

        #define hash table of parameter values for Write-Progress
        $progParam = @{
            Activity         = $MyInvocation.MyCommand
            Status           = "Querying top level folders"
            CurrentOperation = $path
            PercentComplete  = 0
        }

        Write-Progress @progParam

        Write-Verbose "[PROCESS] Get top level folders"
        $top = Get-ChildItem -Path $path -Directory

        #sleeping enough to see the first part of Write-Progress
        Start-Sleep -Milliseconds 300

        #initialize a counter
        $i = 0

        #get the number of files and their total size for each
        #top level folder
        foreach ($folder in $top) {

          #calculate percentage complete
          $i++
          [int]$pct = ($i/$top.count)*100

          #update the param hashtable
          $progParam.CurrentOperation = "Measuring folder size: $($folder.Name)"
          $progParam.Status = "Analyzing"
          $progParam.PercentComplete = $pct

          Write-Progress @progParam

          Write-Verbose "[PROCESS] Calculating folder statistics for $($folder.name)."
          $stats = Get-ChildItem -path $folder.fullname -Recurse -File |
          Measure-Object -Property Length -Sum -Average
          if ($stats.count) {
               $fileCount = $stats.count
               $size = $stats.sum
           }
          else {
               $fileCount = 0
               $size = 0
           }
          #write a custom object result to the pipeline
          [pscustomobject]@{
                Path     = $folder.fullName
                Modified = $folder.LastWriteTime
                Files    = $fileCount
                Size     = $Size
                SizeKB   = [math]::Round($size/1KB, 2)
                SizeMB   = [math]::Round($size/1MB, 2)
                Avg      = [math]::Round($stats.average, 2)
          }
        } #foreach
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}