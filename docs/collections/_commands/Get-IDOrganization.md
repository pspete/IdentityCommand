---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDOrganization

## SYNOPSIS
Get organization details

## SYNTAX

### All (Default)
```
Get-IDOrganization [-Format <String>] [<CommonParameters>]
```

### ID
```
Get-IDOrganization -ID <String> [<CommonParameters>]
```

## DESCRIPTION
Returns organization details, either all organizations in the tenant or a single organization by ID.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDOrganization
```

Returns all organizations in the tenant.

### Example 2
```powershell
PS C:\> Get-IDOrganization -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the specified organization.

## PARAMETERS

### -Format
An optional format specifier for the list of all organizations.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
The unique ID of the organization to retrieve.

```yaml
Type: String
Parameter Sets: ID
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
