function show-output {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        Write-Debug "The Begin Block started."

        Write-Debug "The Begin Block ended."
    }
    
    process {
        Write-Verbose "The Process block started."

        Write-Host "Hello, World!" -foreground Cyan

        Write-Verbose "The process block ended."
    }
    
    end {
        
    }
}


show-output -verbose -debug 
