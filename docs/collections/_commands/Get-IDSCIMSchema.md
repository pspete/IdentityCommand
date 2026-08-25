---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDSCIMSchema

## SYNOPSIS
Get SCIM Schemas

## SYNTAX

```
Get-IDSCIMSchema [[-ID] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns the SCIM schema definitions supported by the tenant, either all schemas or a single schema by ID.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDSCIMSchema
```

Returns all SCIM schema definitions.

## PARAMETERS

### -ID
The unique ID of the resource.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: False
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
