---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Remove-IDUser

## SYNOPSIS
Delete users

## SYNTAX

```
Remove-IDUser [[-ID] <Array>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes one or more users from the cloud directory.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-IDUser -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Deletes the specified user.

### Example 2
```powershell
PS C:\> Remove-IDUser -ID 'a1b2c3d4-0000-0000-0000-000000000000', 'b2c3d4e5-0000-0000-0000-000000000000'
```

Deletes the specified users.

## PARAMETERS

### -ID
The unique IDs of the users to delete.

```yaml
Type: Array
Parameter Sets: (All)
Aliases: Uuid

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### System.Array

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
