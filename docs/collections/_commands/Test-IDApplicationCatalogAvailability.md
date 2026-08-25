---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Test-IDApplicationCatalogAvailability

## SYNOPSIS
Check if an application is still available in the catalog

## SYNTAX

```
Test-IDApplicationCatalogAvailability [-ID] <String> [<CommonParameters>]
```

## DESCRIPTION
Checks whether the application template an application was created from is still available in the application catalog.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-IDApplicationCatalogAvailability -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Checks whether the specified application is still available in the catalog.

## PARAMETERS

### -ID
The unique ID of the application to check.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid, AppKey

Required: True
Position: 0
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
