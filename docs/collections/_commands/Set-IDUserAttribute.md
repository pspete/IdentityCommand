---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDUserAttribute

## SYNOPSIS
Update AD user attributes

## SYNTAX

```
Set-IDUserAttribute [-ID] <String> [[-MobileNumber] <String>] [[-OrgPath] <String>]
 [[-CmaRedirectedUserUuid] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates Active Directory attributes for a specified user.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDUserAttribute -ID 'a1b2c3d4-0000-0000-0000-000000000000' -MobileNumber '18005550100'
```

Updates the specified user's mobile number.

## PARAMETERS

### -CmaRedirectedUserUuid
The UUID of the user to redirect this account's authentication to, if applicable.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ID
The unique ID of the user to update.

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

### -MobileNumber
An updated mobile phone number.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrgPath
An updated organizational path.

```yaml
Type: String
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
