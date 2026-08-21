---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Add-IDRoleMember

## SYNOPSIS
Add users, roles, or groups to a role

## SYNTAX

```
Add-IDRoleMember [-Name] <Object> [[-Users] <Array>] [[-Roles] <Array>] [[-Groups] <Array>]
 [<CommonParameters>]
```

## DESCRIPTION
Adds the specified users, roles, and/or groups as members of an existing role.
Supply one or more of -Users, -Roles, or -Groups with the identifiers of the principals to add; any parameter left unspecified is treated as empty.

## EXAMPLES

### Example 1
```
PS C:\> Add-IDRoleMember -Name 'Role Admins' -Users someuser@somedomain.com
```

Add a user as a member of the role

### Example 2
```
PS C:\> Add-IDRoleMember -Name 'Role Admins' -Roles 'Helpdesk','App Owners' -Groups 'Contractors'
```

Add roles and a group as members of the role

## PARAMETERS

### -Groups
An array of group names (or IDs) to add as members of the role.

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

### -Name
The name (or ID) of the role to add members to.

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

### -Roles
An array of role names (or IDs) to add as nested members of the role.

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
An array of usernames (or IDs) to add as members of the role.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
