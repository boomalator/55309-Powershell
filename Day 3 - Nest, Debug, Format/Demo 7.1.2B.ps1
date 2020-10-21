
# When running the script with -Debug, enter S to suspend.

# Run $data to see what's in the variable. It isn't what
# should have been expected - it's the entire file, not
# a bunch of objects.

# Pipe $data to Get-Member to verify that it's a custom
# object that has a single property, which is the entire
# CSV column header. That's not right.

# The problem is the CSV file. The quotes are making each line
# into a single element. Run the following lines to create
# a modified CSV file.
"name,transaction,qty,amount,total" | Out-File C:\Scripts\Sample.csv
"ctgannon,buy,4,3.00,12.00"  | Out-File C:\Scripts\Sample.csv -Append
"gshields,sell,1200,1.00,1200.00" | Out-File C:\Scripts\Sample.csv -Append
"tevans,sell,8,9.00,72.00" | Out-File C:\Scripts\Sample.csv -Append

# run exit, then enter H to halt the script.
# Re-run the script, again using -Debug.

# When the scirpt runs, enter S to suspend.
# Run $data and verify that there are 3 objects with
# 5 properties apiece.

# Run exit, then enter Y to continue.
# Continue entering Y to continue, until you get the OUTPUT line.
# That doesn't look correct - enter H to halt the command again.
