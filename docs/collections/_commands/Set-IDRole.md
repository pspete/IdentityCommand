---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDRole

## SYNOPSIS
Update role membership

## SYNTAX

```
Set-IDRole [-Name] <Object> [[-AddUsers] <Array>] [[-RemoveUsers] <Array>] [[-AddRoles] <Array>]
 [[-RemoveRoles] <Array>] [[-AddGroups] <Array>] [[-RemoveGroups] <Array>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Adds and/or removes users, roles, and groups from an existing role's membership in a single call.
Use the \`Add \` parameters to add members and the \`Remove \` parameters to remove members; any parameter left unspecified is treated as empty.

## EXAMPLES

### Example 1
```
PS C:\> Set-IDRole -Name 'Role Admins' -AddUsers someuser@somedomain.com -RemoveUsers otheruser@somedomain.com
```

Add one user to the role's membership and remove another

### Example 2
```
PS C:\> Set-IDRole -Name 'Role Admins' -AddRoles 'Helpdesk' -AddGroups 'Contractors'
```

Add a role and a group to the role's membership

## PARAMETERS

### -AddGroups
An array of group names (or IDs) to add to the role's membership.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AddRoles
An array of role names (or IDs) to add to the role's nested membership.

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

### -AddUsers
An array of usernames (or IDs) to add to the role's membership.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name (or ID) of the role to update.

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

### -RemoveGroups
An array of group names (or IDs) to remove from the role's membership.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveRoles
An array of role names (or IDs) to remove from the role's nested membership.

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

### -RemoveUsers
An array of usernames (or IDs) to remove from the role's membership.

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
