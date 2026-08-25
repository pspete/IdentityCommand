---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDSCIMContainerPermission

## SYNOPSIS
Get SCIM Container Permissions

## SYNTAX

```
Get-IDSCIMContainerPermission [[-ID] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns SCIM Container Permissions (Safe memberships), either the full collection or a single permission by ID.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDSCIMContainerPermission -ID 'somepermissionid'
```

Returns the specified SCIM Container Permission.

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
