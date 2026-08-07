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
Import-IDUserCsv [-FileName] <String> [-AdminEmail] <String> [[-DefaultSettings] <Hashtable>]
 [-SendEmailInvite] [-SendSMSInvite] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Imports users in bulk from a previously uploaded CSV file, applying the specified default field values to users where the CSV itself does not specify a value. Orchestrates the two-step bulk import API (register, then commit) into a single command.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-IDUserCsv -FileName 'users.csv' -AdminEmail 'admin@example.com' -SendEmailInvite
```

Imports users from 'users.csv', notifying admin@example.com of the outcome, and sending each imported user an email invite.

## PARAMETERS

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

### -DefaultSettings
A hashtable of default field values (e.g. InEverybodyRole, PasswordNeverExpire) to apply to users imported from the file where the CSV itself does not specify a value.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
The name of the previously uploaded CSV file.

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
