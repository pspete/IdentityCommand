---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Send-IDUserInvite

## SYNOPSIS
Invite cloud users

## SYNTAX

```
Send-IDUserInvite [-Role] <String> [-Entities] <Array> [-EmailInvite] [-SmsInvite] [-GroupInvite] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Invites users, groups, or roles to a role, optionally notifying invited users by email and/or SMS.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Entities = @(@{ Type = 'user'; Guid = 'a1b2c3d4-0000-0000-0000-000000000000'; Name = 'someuser' })
PS C:\> Send-IDUserInvite -Role 'SomeRole' -Entities $Entities -EmailInvite
```

Invites the specified user to 'SomeRole', sending them an email invite.

## PARAMETERS

### -EmailInvite
Sends invited users an email invite.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Entities
An array of hashtables describing the users, groups, or roles to invite: `@{Type='user'; Guid='<userUUID>'; Name='<userName>'}`, `@{Type='role'; Guid='<roleUUID>'; Name='<roleName>'}`, or `@{Type='group'; Guid='<groupUUID>'; Name='<groupName>'}` - all three confirmed live.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupInvite
Sends invited groups an invite.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
The name of the role to invite the specified entities to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmsInvite
Sends invited users an SMS invite.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
