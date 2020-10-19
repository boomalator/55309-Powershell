---
external help file: TMSample-help.xml
Module Name: TMSample
online version:
schema: 2.0.0
---

# Get-TMTrustedHosts

## SYNOPSIS

Get TrustedHosts settings from a remote computer.

## SYNTAX

### computer (Default)

```yaml
Get-TMTrustedHosts [-ComputerName] <String[]> [<CommonParameters>]
```

### session

```yaml
Get-TMTrustedHosts [-PSSession <PSSession[]>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to connect to a remote computer and determine what values it has for TrustedHosts. You can connect to a computer by its name or an existing PSSession.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-TMTrustedHosts -computername SRV1
```

Get trusted hosts information for SRV1.

### Example 2

```powershell
PS C:\> Get-PSSession | Get-TMTrustedHosts | Export-CSV c:\work\trusted.csv
```

Get trusted hosts settings using all of the existing PSSessions and export results to a CSV file.

## PARAMETERS

### -ComputerName

Specify the name of a remote computer.

```yaml
Type: String[]
Parameter Sets: computer
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PSSession

Specify an existing PSSession.

```yaml
Type: PSSession[]
Parameter Sets: session
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Connect-WSMan]()
