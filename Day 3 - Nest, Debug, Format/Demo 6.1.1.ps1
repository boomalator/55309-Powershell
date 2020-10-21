Get-Service | Export-CSV services.csv
notepad services.csv

# Note how the Dependent services are listed... this is
# how a flat file like CSV represents a collection of objects

