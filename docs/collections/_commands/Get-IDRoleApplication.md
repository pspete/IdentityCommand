---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDRoleApplication

## SYNOPSIS
Get applications assigned to a role

## SYNTAX

```
Get-IDRoleApplication [-Name] <Object> [<CommonParameters>]
```

## DESCRIPTION
Returns the applications that are assigned to the specified role.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDRoleApplication -Name 'Role Admins'
```

Return the applications assigned to the role

## PARAMETERS

### -Name
The name (or ID) of the role to get assigned applications for.

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
