---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDOrganizationAdministrator

## SYNOPSIS
Update organization administrators

## SYNTAX

```
Set-IDOrganizationAdministrator [-OrgId] <String> [[-Grant] <Array>] [[-Revoke] <Array>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Grants and/or revokes administrator status for an organization in a single call.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Grant = @(@{ DirectoryServiceUuid = '09B9A9B0-6CE8-465F-AB03-65766D33B05E'; Id = 'a1b2c3d4-0000-0000-0000-000000000000'; SystemName = 'someuser@example.com'; Type = 'User' })
PS C:\> Set-IDOrganizationAdministrator -OrgId 'b2c3d4e5-0000-0000-0000-000000000000' -Grant $Grant
```

Grants the specified user administrator status on the organization.

## PARAMETERS

### -Grant
An array of hashtables describing administrators to grant, e.g. `@{DirectoryServiceUuid='...'; Id='<userUUID>'; SystemName='<user>'; Type='User'}`.

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
An array of hashtables describing administrators to revoke, e.g. `@{Id='<userUUID>'}`.

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
