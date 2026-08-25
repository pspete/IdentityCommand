---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Import-IDUserCsv

## SYNOPSIS
Bulk import users from a CSV file

## SYNTAX

```
Import-IDUserCsv [-Path] <String> [-AdminEmail] <String> [-SendEmailInvite] [-SendSMSInvite]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Uploads a local CSV file and imports the users it contains. Orchestrates the two-step bulk import API (upload, then commit) into a single command, returning an object with `Success` and `Message` properties.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-IDUserCsv -Path .\users.csv -AdminEmail 'admin@example.com' -SendEmailInvite
```

Uploads and imports users from 'users.csv', notifying admin@example.com of the outcome, and sending each imported user an email invite.

## PARAMETERS

### -Path
Path to the local CSV file to upload and import.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminEmail
The email address to notify of the import's outcome.

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

### -SendEmailInvite
Sends each imported user an email invite.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SendSMSInvite
Sends each imported user an SMS invite.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
