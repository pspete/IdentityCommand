---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDSCIMContainer

## SYNOPSIS
Get SCIM Containers

## SYNTAX

```
Get-IDSCIMContainer [[-ID] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns SCIM Containers (Safes), either the full collection or a single Container by ID.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDSCIMContainer -ID 'somecontainerid'
```

Returns the specified SCIM Container.

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
