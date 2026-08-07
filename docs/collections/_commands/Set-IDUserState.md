---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDUserState

## SYNOPSIS
Set a user's state

## SYNTAX

### ByState (Default)
```
Set-IDUserState -ID <String> -State <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByEnabled
```
Set-IDUserState -ID <String> -Enabled <Boolean> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets a user's state, either to a named state value or to a simple enabled/disabled boolean. These map to two distinct underlying API operations that both describe themselves as setting user state.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDUserState -ID 'a1b2c3d4-0000-0000-0000-000000000000' -State 'None'
```

Sets the specified user's state value.

### Example 2
```powershell
PS C:\> Set-IDUserState -ID 'a1b2c3d4-0000-0000-0000-000000000000' -Enabled $false
```

Disables the specified user.

## PARAMETERS

### -Enabled
Whether the user is enabled.

```yaml
Type: Boolean
Parameter Sets: ByEnabled
Aliases:

Required: True
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -State
The state value to set.

```yaml
Type: String
Parameter Sets: ByState
Aliases:

Required: True
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
