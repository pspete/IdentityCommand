---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDTenantMessageTemplate

## SYNOPSIS
Get editable message templates

## SYNTAX

### All (Default)
```
Get-IDTenantMessageTemplate [<CommonParameters>]
```

### Named
```
Get-IDTenantMessageTemplate -TemplateName <String> -TemplateType <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the editable message templates (e.g. invitation/notification emails) configured for the tenant, either all of them or a single named template.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDTenantMessageTemplate
```

Returns all editable message templates.

### Example 2
```powershell
PS C:\> Get-IDTenantMessageTemplate -TemplateName 'audiomessage_challenge_failure' -TemplateType 'AudioMessage'
```

Returns the specified message template.

## PARAMETERS

### -TemplateName
The template's internal identifier - the `TemplateName` property of a row from the `-All` set (e.g. `'audiomessage_challenge_failure'`), not its display `Name`. Passing the display Name instead still returns a 200 response with plausible-looking constructed paths, but silently omits the template's actual content (`FileText`).

```yaml
Type: String
Parameter Sets: Named
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TemplateType
The template's type - the `Type` property of a row from the `-All` set (e.g. `'AudioMessage'`). The full set of valid values is otherwise undocumented.

```yaml
Type: String
Parameter Sets: Named
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
