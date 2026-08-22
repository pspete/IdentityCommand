---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Add-IDRolePermission

## SYNOPSIS
Assign an administrative permission to a role

## SYNTAX

```
Add-IDRolePermission [-ID] <Object> [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Grants a role an administrative permission (super right), identified by its permission path.
The path must match one of the values returned by \`Get-IDPermission\`; if it does not, a warning is written and the command stops without making the call.

## EXAMPLES

### Example 1
```
PS C:\> Add-IDRolePermission -ID '881512ca-d441-4997-a55e-19ec5374f3b3' -Path '/Core/ManageUsers'
```

Assign the specified administrative permission to the role

## PARAMETERS

### -ID
The ID/UUID/`_RowKey` of the role to assign the permission to - not its display name.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
The path of the administrative permission (super right) to assign to the role.
Must be one of the paths returned by \`Get-IDPermission\`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
