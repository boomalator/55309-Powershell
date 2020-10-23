import-csv 'employees.csv' |
    ConvertTo-Xml -As "string" | Out-File "Employees.xml"

import-csv 'employees.csv' |
    ConvertTo-Json | Out-File "Employees.json"

