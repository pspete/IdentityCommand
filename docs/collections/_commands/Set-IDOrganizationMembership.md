---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDOrganizationMembership

## SYNOPSIS
Update organization membership

## SYNTAX

```
Set-IDOrganizationMembership [-ID] <String> [[-Add] <Array>] [[-Remove] <Array>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Adds and/or removes members of an organization in a single call.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Add = @(@{ ID = 'a1b2c3d4-0000-0000-0000-000000000000'; Type = 'User' })
PS C:\> Set-IDOrganizationMembership -ID 'b2c3d4e5-0000-0000-0000-000000000000' -Add $Add
```

Adds the specified user to the organization.

## PARAMETERS

### -Add
An array of hashtables describing members to add, e.g. `@{ID='<userUUID>'; Type='User'}`.

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

### -ID
The unique ID of the organization to update.

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

### -Remove
An array of hashtables describing members to remove, e.g. `@{ID='<userUUID>'; Type='User'}`.

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
