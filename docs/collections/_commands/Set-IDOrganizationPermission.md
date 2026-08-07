---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDOrganizationPermission

## SYNOPSIS
Update organization administrative rights

## SYNTAX

```
Set-IDOrganizationPermission [-OrgId] <String> [[-Grant] <Array>] [[-Revoke] <Array>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Grants and/or revokes administrative rights on an organization in a single call.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Grant = @(@{ Right = 'View'; Principal = 'someuser@example.com'; PrincipalType = 'User' })
PS C:\> Set-IDOrganizationPermission -OrgId 'a1b2c3d4-0000-0000-0000-000000000000' -Grant $Grant
```

Grants the specified user the 'View' right on the organization.

## PARAMETERS

### -Grant
An array of hashtables describing rights to grant, e.g. `@{Right='<right>'; Principal='<principal>'; PrincipalType='<type>'}`.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrgId
The unique ID of the organization to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Revoke
An array of hashtables describing rights to revoke, e.g. `@{Right='<right>'; Principal='<principal>'}`.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
