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
Get-IDRoleMember [-Name] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns the users, roles, and groups that are members of the specified role.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDRoleMember -Name 'Role Admins'
```

Return the members of the role

## PARAMETERS

### -Name
The name (or ID) of the role to get members of.

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
