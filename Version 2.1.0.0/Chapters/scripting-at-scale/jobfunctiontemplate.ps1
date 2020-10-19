Function Get-Foo {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        $This,
        $That,
        $TheOtherThing
    )

    Begin {
      #initialize an array to hold job objects
      $jobs = @()

      $mycode = {
         #define your code to run with parameters if necessary
         #parameters will need to be passed positionally
         Param($this, $that)
         #awesome PowerShell code goes here
        }
    }

    Process {
      #add the job to the array
      $jobs += Start-Job -ScriptBlock $mycode -ArgumentList $this, $that
    }

    End {
     #wait for all jobs to complete
     Write-Host "Waiting for background jobs to complete" -ForegroundColor Yellow
     $jobs | Wait-Job

     #receive job results
     #or bring job results back in to the function and do
     #something with them
     $jobs |
     Get-Job -ChildJobState Completed -HasMoreData $True |
     Receive-Job -keep
    }

}