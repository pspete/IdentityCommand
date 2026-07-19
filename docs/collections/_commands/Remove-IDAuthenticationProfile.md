---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Remove-IDAuthenticationProfile

## SYNOPSIS
Delete an authentication profile

## SYNTAX

```
Remove-IDAuthenticationProfile [-Name] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Delete an authentication profile from the tenant by its unique ID.

## EXAMPLES

### Example 1
```
PS C:\> Remove-IDAuthenticationProfile -Name 1234-abcd-5678-efgh
```

Delete the authentication profile with the matching ID.

## PARAMETERS

### -Name
The unique ID (Uuid) of the authentication profile to delete.
Also aliased as Uuid.
Accepts pipeline input by property name.

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

### System.Object
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
