---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDDynamicRoleScript

## SYNOPSIS
Set the membership script for a dynamic role

## SYNTAX

```
Set-IDDynamicRoleScript [-ID] <Object> [-Script] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets (or replaces) the script used to compute membership for a script-based (dynamic) role.
Use \`Test-IDDynamicRoleScript\` to validate a script against a user before applying it here.

## EXAMPLES

### Example 1
```
PS C:\> Set-IDDynamicRoleScript -ID '<role-id>' -Script 'function isRoleMember(user) { return user.Email.endsWith("@somedomain.com"); }'
```

Set the membership script for the dynamic role

## PARAMETERS

### -ID
The dynamic role's ID/UUID/`_RowKey` (not its display name) to set the membership script for. The role must have been created with `-RoleType Script` (see `New-IDRole`).

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

### -Script
The script text that defines the role's membership logic.

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
