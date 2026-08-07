---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Test-IDUserLockedOutByPolicy

## SYNOPSIS
Check if a user is locked out by policy

## SYNTAX

```
Test-IDUserLockedOutByPolicy [-ID] <String> [<CommonParameters>]
```

## DESCRIPTION
Checks whether a specified user is currently locked out as a result of tenant policy (e.g. too many failed login attempts).

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-IDUserLockedOutByPolicy -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Checks whether the specified user is locked out by policy.

## PARAMETERS

### -ID
The unique ID of the user to check.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: True
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
