---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDOrganizationRole

## SYNOPSIS
Get organization roles

## SYNTAX

```
Get-IDOrganizationRole [-ID] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the roles associated with an organization.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDOrganizationRole -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the roles associated with the specified organization.

## PARAMETERS

### -ID
The unique ID of the organization to get roles for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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
