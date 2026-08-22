---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDRoleMember

## SYNOPSIS
Get members of a role

## SYNTAX

```
Get-IDRoleMember [-ID] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns the users, roles, and groups that are members of the specified role.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDRoleMember -ID '881512ca-d441-4997-a55e-19ec5374f3b3'
```

Return the members of the role

## PARAMETERS

### -ID
The ID/UUID/`_RowKey` of the role to get members of - not its display name.

```yaml
Type: Object
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

### System.Object
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
