---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDConnector

## SYNOPSIS
Get Connector Status

## SYNTAX

```
Get-IDConnector [[-proxyUuid] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieve health status of all connectors, or specific connector

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDConnector
```

Get status of all connectors

### Example 2
```powershell
PS C:\> Get-IDConnector -proxyUuid 1234
```

Get status of specific connectors

## PARAMETERS

### -proxyUuid
The ID of the cloud connector to check

```yaml
Type: String
Parameter Sets: (All)
Aliases: ID

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
