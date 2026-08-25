---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDUserPassword

## SYNOPSIS
Change the current user's password

## SYNTAX

```
Set-IDUserPassword [-OldPassword] <SecureString> [-NewPassword] <SecureString> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Changes the current user's password, given their existing password.

**CAUTION - this is self-service only.** `UserMgmt/ChangeUserPassword` has no user-targeting field, so this always changes the password of whichever account the current session is authenticated as - there is no way to change another user's password via this command. `$ISPSSSession.User` is used only for the `-WhatIf`/`-Confirm` message, it is not sent in the request body. The server also does not appear to validate `-OldPassword` against the session user's actual current password.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Old = Read-Host -AsSecureString
PS C:\> $New = Read-Host -AsSecureString
PS C:\> Set-IDUserPassword -OldPassword $Old -NewPassword $New
```

Changes the current user's password.

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

### -NewPassword
The new password.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OldPassword
The current password.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
