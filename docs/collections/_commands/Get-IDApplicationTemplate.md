---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDApplicationTemplate

## SYNOPSIS
Get available application templates and categories

## SYNTAX

```
Get-IDApplicationTemplate [<CommonParameters>]
```

## DESCRIPTION
Returns the application templates and categories available for creating new applications with `New-IDApplication`.
The result exposes `Templates` (flattened from the underlying `AppTemplates.Results.Row` structure) and `Categories` properties.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplicationTemplate
```

Returns all available application templates and categories.

### Example 2
```powershell
PS C:\> (Get-IDApplicationTemplate).Templates | Where-Object Category -eq 'Finance'
```

Returns the application templates in the 'Finance' category.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
