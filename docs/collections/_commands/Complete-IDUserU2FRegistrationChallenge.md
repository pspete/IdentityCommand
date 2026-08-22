---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Complete-IDUserU2FRegistrationChallenge

## SYNOPSIS
Complete a U2F device registration challenge

## SYNTAX

```
Complete-IDUserU2FRegistrationChallenge [-RawRegisterResponse] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Submits the result of a completed browser WebAuthn registration ceremony (started via `Get-IDUserU2FRegistrationChallenge`) to finish enrolling a new U2F device for the current user. `-RawRegisterResponse` must be the JSON-stringified response from the browser's `navigator.credentials.create()` call, answering the challenge returned by `Get-IDUserU2FRegistrationChallenge` - this module cannot produce that value itself, since it requires a real WebAuthn ceremony with physical/platform authenticator hardware inside a browser.

## EXAMPLES

### Example 1
```powershell
PS C:\> Complete-IDUserU2FRegistrationChallenge -RawRegisterResponse $RawRegisterResponseJson
```

Completes registration of a new U2F device using a previously-obtained WebAuthn response.

## PARAMETERS

### -RawRegisterResponse
The JSON-stringified result of the browser's `navigator.credentials.create()` call.

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
