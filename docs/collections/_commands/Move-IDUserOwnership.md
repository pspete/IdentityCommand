---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Move-IDUserOwnership

## SYNOPSIS
Transfer ownership of everything one or more users own

## SYNTAX

### TargetUser (Default)
```
Move-IDUserOwnership [-Users] <String[]> [-TargetUser] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### TransferToManager
```
Move-IDUserOwnership [-Users] <String[]> [-TransferToManager] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Transfers ownership of everything the specified users own (applications, secured items, notes, etc.) to another user, or to each user's manager.

## EXAMPLES

### Example 1
```powershell
PS C:\> Move-IDUserOwnership -Users 'a1b2c3d4-0000-0000-0000-000000000000' -TargetUser 'newowner@example.com'
```

Transfers everything owned by the specified user to 'newowner@example.com'.

### Example 2
```powershell
PS C:\> Move-IDUserOwnership -Users 'a1b2c3d4-0000-0000-0000-000000000000' -TransferToManager
```

Transfers everything owned by the specified user to that user's manager.

## PARAMETERS

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

### -TargetUser
The username of the user to transfer ownership to.

```yaml
Type: String
Parameter Sets: TargetUser
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TransferToManager
Transfer ownership to each user's manager instead of a specific target user.

```yaml
Type: SwitchParameter
Parameter Sets: TransferToManager
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Users
The unique ID(s) of the user(s) to transfer ownership from.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Uuid, ID

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
