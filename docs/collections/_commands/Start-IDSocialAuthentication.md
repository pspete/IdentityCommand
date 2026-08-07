---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Start-IDSocialAuthentication

## SYNOPSIS
Start a social (external IdP) authentication flow

## SYNTAX

```
Start-IDSocialAuthentication [-IdpName] <String> [-CallbackUrl] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Starts a redirect-based authentication flow against an external identity provider (social login). This command only performs the 'start' call - completing the flow requires the external IdP to redirect back to -CallbackUrl, which is not handled by this module.

## EXAMPLES

### Example 1
```powershell
PS C:\> Start-IDSocialAuthentication -IdpName 'SomeIdp' -CallbackUrl 'https://myapp.example.com/callback'
```

Starts a social authentication flow against the specified external identity provider.

## PARAMETERS

### -CallbackUrl
The URL the external identity provider should redirect back to after authentication.

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

### -IdpName
The name of the external identity provider to authenticate against.

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
