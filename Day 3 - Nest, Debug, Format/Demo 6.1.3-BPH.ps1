# Note how XML is capable of retaining the hierarchy
Get-Service | Export-CliXML services.xml
notepad services.xml

# Note how the collection is now expanded into its
# own flat file format
Get-Service  | Select-Object -Expand DependentServices | Export-CSV services.csv
notepad services.csv

Get-Service  | Format-Custom * 

$AllServices = Get-Service
Foreach ($oneService in $AllServices) {
    Foreach ($depService in $oneService.RequiredServices) {
        Write-Host "$($OneService.Name) depends on $($depService.name)"
    }
}

Write-Host "Service $($AllServices[-1].Name) depends on $($AllServices[-1].RequiredServices[0].name)"

