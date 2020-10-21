function show-name {
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]] $name 
    )

    Begin {}

    Process { 
        foreach ($oneName in $name) {
            Write-Host "Hello! My name is $oneName"
        }
    }

    End {}
}


show-name "Thing1", "Thing2"
"Thing3", "Thing4" | show-name