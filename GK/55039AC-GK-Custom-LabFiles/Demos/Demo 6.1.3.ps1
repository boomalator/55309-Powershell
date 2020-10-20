# Note how the collection is now expanded into its
# own flat file format
Get-Service | Select-Object -Expand DependentServices | Export-CSV services.csv
notepad services.csv

# Note how XML is capable of retaining the hierarchy
Get-Service | Export-CliXML services.xml
notepad services.xml

