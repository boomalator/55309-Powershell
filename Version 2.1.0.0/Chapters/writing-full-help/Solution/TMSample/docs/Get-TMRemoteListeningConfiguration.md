---
external help file: TMSample-help.xml
Module Name: TMSample
online version:
schema: 2.0.0
---

# Get-TMRemoteListeningConfiguration

## SYNOPSIS

Test remote listening ports.

## SYNTAX

```yaml
Get-TMRemoteListeningConfiguration [-Computername] <String[]> [[-ErrorLog] <String>] [<CommonParameters>]
```

## DESCRIPTION

This command will be used to test the network listening configuration on one or more remote computers. It will test if standard PowerShell remoting is enabled on both ports 5985 and 5986. It will also test if SSH is enabled on port 22.

Because the command is testing at the network layer, you do not need to use any credentials.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-TMRemoteListeningConfiguration -Computername srv1

Computername  : SRV1
Date          : 7/28/2020 5:13:57 PM
WSManHTTP     : True
RemoteAddress : 192.168.3.50
WSManHTTPS    : False
SSH           : False
```

Get configuration information for a single computer.

### Example 2

```powershell
PS C:\> Get-Content c:\work\computers.txt | Get-TMRemoteListeningConfiguration -errorlog c:\work\tmerrors.txt | Export-CSV c:\work\results.csv -NoTypeinformation
```

Get remote listening information for every computer in the computers.txt file and export results to a CSV file. Any errors will be logged to c:\work\tmerrors.txt.


## PARAMETERS

### -Computername

Specify the name of IP address of a remote computer.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: CN

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ErrorLog

Specify the path to a text file to log errors. Entries will be automatically appended. Make sure the folder location exists.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Test-NetConnection]()
