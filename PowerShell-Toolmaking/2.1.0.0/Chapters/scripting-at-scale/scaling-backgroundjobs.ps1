
#create a big list of names from whatever list you want to use
$computers = 1..5 | ForEach-Object {Get-Content C:\scripts\servers.txt}


#using nothing 52 sec
#85 items 4:45
Measure-Command {
    $all = foreach ($item in $computers) {
        Test-WSMan $item
    }
}

#using background jobs 56 sec
#85 items 4:32
Measure-Command {
    $all = @()
    $all += foreach ($item in $computers) {
        Start-Job {Test-WSMan $item}
    }
    $all | Wait-Job | Receive-Job -Keep
}

#basic runspace
$run = [powershell]::Create()
$run.AddCommand("test-wsman").addparameter("computername", $env:computername)
$handle = $run.beginInvoke()
$results = $run.EndInvoke($handle)
$run.Dispose()

#using runspaces 10sec
#85 items 16 seconds
Measure-Command {
    #initialize an array to hold runspaces
    $rspace = @()

    #create a runspace for each computer
    foreach ($item in $computers) {
        $run = [powershell]::Create()
        $run.AddCommand("test-wsman").addparameter("computername", $item)
        $handle = $run.beginInvoke()
        #add the handle as a property to make it easier to reference later
        $run | Add-Member -MemberType NoteProperty -Name Handle -Value $handle
        $rspace += $run
    }

    <# alternative
While ($rspace.invocationStateInfo.state -contains "running") {
 #loop and wait
}
#>

    While (-Not $rspace.handle.isCompleted) {
        #an empty loop waiting for everything to complete
    }

    #get results
    $results = @()
    for ($i = 0; $i -lt $rspace.count; $i++) {
        $results += $rspace[$i].EndInvoke($rspace[$i].handle)
    }

    #cleanup
    $rspace.ForEach( {$_.dispose()})

}