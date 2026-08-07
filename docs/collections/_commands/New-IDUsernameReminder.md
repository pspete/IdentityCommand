---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDUsernameReminder

## SYNOPSIS
Request a username reminder

## SYNTAX

### SearchKey (Default)
```
New-IDUsernameReminder -tenant_url <String> -SearchKey <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Interactive
```
New-IDUsernameReminder -tenant_url <String> [-Interactive] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Requests a username reminder from the tenant, either as a one-shot lookup by a search key (e.g. email address) or via an interactive, challenge-gated session. This is a pre-authentication flow, so it takes -tenant_url explicitly rather than relying on an existing session from New-IDSession.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDUsernameReminder -tenant_url 'https://example.id.cyberark.cloud' -SearchKey 'someuser@example.com'
```

Requests a username reminder be sent for the account matching the specified email address.

### Example 2
```powershell
PS C:\> New-IDUsernameReminder -tenant_url 'https://example.id.cyberark.cloud' -Interactive
```

Starts an interactive, challenge-gated username reminder session, prompting for the first challenge mechanism's answer.

## PARAMETERS

### -Interactive
Starts a challenge-gated session rather than performing a one-shot lookup.

```yaml
Type: SwitchParameter
Parameter Sets: Interactive
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchKey
A search key (e.g. an email address) identifying the account to send a username reminder for.

```yaml
Type: String
Parameter Sets: SearchKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenant_url
The base URL of the Identity tenant.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
