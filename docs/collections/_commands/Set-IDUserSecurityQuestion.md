---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDUserSecurityQuestion

## SYNOPSIS
Update a user's security questions

## SYNTAX

```
Set-IDUserSecurityQuestion [-ID] <String> [[-Added] <Array>] [[-Deleted] <Array>] [-Replace] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds, removes, or replaces a user's security questions.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Added = @(@{ Question = 'What was your first pet'; Answer = 'Rex' })
PS C:\> Set-IDUserSecurityQuestion -ID 'a1b2c3d4-0000-0000-0000-000000000000' -Added $Added
```

Adds a new security question for the specified user.

## PARAMETERS

### -Added
An array of new security questions to add, e.g. `@{Question='...'; Answer='...'}`.

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

### -Deleted
An array of existing security question IDs to remove.

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

### -ID
The unique ID of the user to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Replace
Replaces all existing security questions rather than appending/removing individual ones.

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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
