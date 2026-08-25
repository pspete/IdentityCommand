---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Send-IDUserIdentityVerification

## SYNOPSIS
Challenge a user's identity verification mechanism

## SYNTAX

```
Send-IDUserIdentityVerification [-ID] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Starts an identity verification challenge for a user and works through it - the same mechanism-selection/challenge/answer system used for interactive login (`New-IDSession`), but initiated by an admin against a target user rather than the user authenticating themselves.

When the user has more than one enrolled mechanism, you're prompted interactively to choose one, exactly as during login. Out-of-band mechanisms (e.g. Email) are challenged and then polled automatically until answered. Direct-answer mechanisms (e.g. OATH) prompt you for the code.

## EXAMPLES

### Example 1
```powershell
PS C:\> Send-IDUserIdentityVerification -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Starts an identity verification challenge for the specified user, prompting for a mechanism if more than one is enrolled.

## PARAMETERS

### -ID
The unique ID of the user being verified.

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
