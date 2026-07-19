---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDRole

## SYNOPSIS
Create a new role

## SYNTAX

```
New-IDRole [-Name] <Object> [[-Description] <Object>] [[-Users] <Array>] [[-Roles] <Array>] [[-Groups] <Array>]
 [[-RoleType] <Object>] [[-OrgPath] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new role in the tenant, optionally seeding it with initial user, role, and group members.
Use -RoleType to control how role membership is determined.

## EXAMPLES

### Example 1
```
PS C:\> New-IDRole -Name 'Role Admins' -Description 'Administers roles and permissions'
```

Create a new, empty role

### Example 2
```
PS C:\> New-IDRole -Name 'Role Admins' -Users someuser@somedomain.com -Groups 'Contractors'
```

Create a new role with initial user and group members

## PARAMETERS

### -Description
A description of the new role.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Groups
An array of group names (or IDs) to add as initial members of the new role.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the role to create.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrgPath
The organizational path under which to create the role, if the tenant uses organizational units for roles.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleType
The type of role to create.
\`PrincipalList\` (the default) creates a role whose membership is an explicit list of users, roles, and groups.
\`Script\` creates a dynamic role whose membership is computed by a script (see \`Set-IDDynamicRoleScript\`).
\`Everybody\` creates a role that automatically includes every user in the tenant.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: PrincipalList, Script, Everybody

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Roles
An array of role names (or IDs) to add as initial nested members of the new role.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Users
An array of usernames (or IDs) to add as initial members of the new role.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Default value: None
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
