# Assumes you copied Demo 8.1.5.ps1xml to C:\Scripts\test.format.ps1xml.
Update-FormatData -PrependPath C:\Scripts\test.format.ps1xml

# Note the error and use Demo 8.1.6B.ps1xml instead
# Copy that to c:\Scripts\test.format.ps1xml
# Then run
Update-FormatData -PrependPath C:\Scripts\test.format.ps1xml

# Should run without error