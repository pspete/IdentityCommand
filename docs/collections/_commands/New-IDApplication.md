---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDApplication

## SYNOPSIS
Create a new application from a template

## SYNTAX

```
New-IDApplication [-TemplateName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new application in the tenant by importing it from one of the available application templates. The application is created with the template's own name - there is no way to rename it at creation time; use `Set-IDApplication` afterward if you need a different name.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDApplication -TemplateName 'GenericSAML'
```

Creates a new application from the 'GenericSAML' template.

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

### -TemplateName
The name of the application template to import from (this is the same value as the template's `ID`). Use `Get-IDApplicationTemplate` to list available templates.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ID

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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
