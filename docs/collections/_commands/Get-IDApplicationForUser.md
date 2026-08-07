---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDApplicationForUser

## SYNOPSIS
Get applications available to a user

## SYNTAX

```
Get-IDApplicationForUser [-UserUuid] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the applications resolved (resultant) for the specified user.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplicationForUser -UserUuid 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the applications available to the specified user.

## PARAMETERS

### -UserUuid
The unique ID of the user.

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
