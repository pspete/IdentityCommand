---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUserHierarchy

## SYNOPSIS
Get user hierarchy

## SYNTAX

```
Get-IDUserHierarchy [[-ID] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns the organizational/management hierarchy for a specified user, or the current user if -ID is not supplied.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDUserHierarchy
```

Returns the hierarchy for the current user.

### Example 2
```powershell
PS C:\> Get-IDUserHierarchy -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the hierarchy for the specified user.

## PARAMETERS

### -ID
The unique ID of the user to get the hierarchy for. Defaults to the current user if not supplied.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
