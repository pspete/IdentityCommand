---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDApplicationPermission

## SYNOPSIS
Set permissions on an application

## SYNTAX

```
Set-IDApplicationPermission [-ID] <String> [-Grants] <Array> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets the full list of permission grants (users, roles, or groups, and their rights) on an application.
This replaces the existing permission set for the application with the one supplied.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Grants = @(
    @{ 'Principal' = 'someuser@somedomain.com'; 'PType' = 'User'; 'Rights' = 'View,Run' }
)
PS C:\> Set-IDApplicationPermission -ID 'a1b2c3d4-0000-0000-0000-000000000000' -Grants $Grants
```

Grants the specified user View and Run rights on the application.

## PARAMETERS

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

### -Grants
An array of permission grant objects to apply to the application. Each entry defines a principal (user, role, or group), its type, and the rights to assign.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
The unique ID of the application on which to set permissions.

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
