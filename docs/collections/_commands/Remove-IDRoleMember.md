---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Remove-IDRoleMember

## SYNOPSIS
Remove users, roles, or groups from a role

## SYNTAX

```
Remove-IDRoleMember [-ID] <Object> [[-Users] <Array>] [[-Roles] <Array>] [[-Groups] <Array>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes the specified users, roles, and/or groups from the membership of an existing role.
Supply one or more of -Users, -Roles, or -Groups with the identifiers of the principals to remove; any parameter left unspecified is treated as empty.

## EXAMPLES

### Example 1
```
PS C:\> Remove-IDRoleMember -ID '881512ca-d441-4997-a55e-19ec5374f3b3' -Users someuser@somedomain.com
```

Remove a user from the role's membership

### Example 2
```
PS C:\> Remove-IDRoleMember -ID '881512ca-d441-4997-a55e-19ec5374f3b3' -Roles 'Helpdesk' -Groups 'Contractors'
```

Remove a role and a group from the role's membership

## PARAMETERS

### -Groups
An array of group names (or IDs) to remove from the role's membership.

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

### -ID
The ID/UUID/`_RowKey` of the role to remove members from - not its display name (confirmed live).

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

### -Roles
An array of role names (or IDs) to remove from the role's nested membership.

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

### -Users
An array of usernames (or IDs) to remove from the role's membership.

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
