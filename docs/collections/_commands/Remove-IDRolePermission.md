---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Remove-IDRolePermission

## SYNOPSIS
Remove an administrative permission from a role

## SYNTAX

```
Remove-IDRolePermission [-Name] <Object> [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Revokes an administrative permission (super right) from a role, identified by its permission path.
The path must match one of the values returned by \`Get-IDPermission\`; if it does not, a warning is written and the command stops without making the call.

## EXAMPLES

### Example 1
```
PS C:\> Remove-IDRolePermission -Name 'Role Admins' -Path '/Core/ManageUsers'
```

Remove the specified administrative permission from the role

## PARAMETERS

### -Name
The name (or ID) of the role to remove the permission from.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Uuid, ID

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
The path of the administrative permission (super right) to remove from the role.
Must be one of the paths returned by \`Get-IDPermission\`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
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
