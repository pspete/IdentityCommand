---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Copy-IDApplication

## SYNOPSIS
Clone an existing application

## SYNTAX

```
Copy-IDApplication [-Key] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a copy of an existing application.

## EXAMPLES

### Example 1
```powershell
PS C:\> Copy-IDApplication -Key 'a1b2c3d4-0000-0000-0000-000000000000'
```

Clones the specified application.

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

### -Key
The unique ID of the application to clone.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ID, Uuid, AppKey

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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
