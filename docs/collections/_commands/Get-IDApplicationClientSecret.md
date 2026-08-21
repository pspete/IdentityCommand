---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDApplicationClientSecret

## SYNOPSIS
Get the OpenID Connect client secret for an application

## SYNTAX

```
Get-IDApplicationClientSecret [-OIDCAppKey] <String> [-PublicKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the OpenID Connect client secret for an OIDC web application. Kept separate from `Get-IDApplication` since it returns sensitive credential data. The response contains the secret encrypted with the supplied `-PublicKey` (RSA-OAEP) under an `e` property if encryption succeeds, or in plain text under a `p` property if it fails - decrypting an `e` response is left to the caller.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplicationClientSecret -OIDCAppKey 'a1b2c3d4-0000-0000-0000-000000000000' -PublicKey $PublicKeyString
```

Returns the OIDC client secret for the specified application, encrypted with the supplied public key.

## PARAMETERS

### -OIDCAppKey
The unique RowKey/AppKey of the OIDC web application.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid, AppKey, ID

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PublicKey
An RSA-OAEP public key used to encrypt the returned secret.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
