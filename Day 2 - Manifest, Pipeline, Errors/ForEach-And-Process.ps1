function Show-TheThing {
    [CmdletBinding()]
    param (
        [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True)]
        [int[]] $thing
    )
    
    begin {
        Write-Verbose "Entering 'Begin' - `$thing = ~$thing~"
    }
    
    process {
        Write-Verbose "Entering 'Process' - `$thing = ~$thing~"
        foreach ($singleThing in $thing) {
            Write-Verbose "Top of ForEach Loop"  
            Write-Verbose "   `$thing = ~$thing~"
            Write-Host    "   `$singleThing = ~$singlething~"
        }
    }
    
    end {
        Write-Verbose "Entering 'End'"
    }
}

# When an array is passed on the parameter, the function sees
# one array (a collection), containing three values.
Show-TheThing -thing 1, 2, 3 -Verbose

# When an array is passed on the pipeline, the function sees
# three collections in a row, each being a collection of one value.
1, 2, 3 | Show-TheThing -Verbose

<#

Without a PROCESS block, but with a FOREACH loop, the loop will only process the LAST object passed on the pipeline. 
With a PROCESS block, but without a FOREACH loop, the an array on the parameter will not be enumerated.

In all practical situations, if you accept multiple inputs, 
and you accept values from the pipeline (and you should!), 
you will have a FOREACH inside of a PROCESS block.

#>