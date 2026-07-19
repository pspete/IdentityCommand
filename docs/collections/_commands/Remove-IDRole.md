---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Remove-IDRole

## SYNOPSIS
Delete one or more roles

## SYNTAX

```
Remove-IDRole [[-Roles] <Array>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Permanently deletes the specified roles from the tenant.

## EXAMPLES

### Example 1
```
PS C:\> Remove-IDRole -Roles 'Role Admins','Old Role'
```

Delete the specified roles

## PARAMETERS

### -Roles
An array of role names (or IDs) to delete.
Accepts pipeline input by property name.

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
