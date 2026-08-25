---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUserU2FDevice

## SYNOPSIS
Get U2F devices

## SYNTAX

```
Get-IDUserU2FDevice [[-Type] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns the current user's registered U2F devices, optionally filtered by device type.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDUserU2FDevice
```

Returns all registered U2F devices for the current user.

## PARAMETERS

### -Type
Filters devices to a specific type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
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
