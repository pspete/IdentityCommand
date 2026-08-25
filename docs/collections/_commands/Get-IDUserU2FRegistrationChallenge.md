---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUserU2FRegistrationChallenge

## SYNOPSIS
Get a U2F device registration challenge

## SYNTAX

```
Get-IDUserU2FRegistrationChallenge [-UserDefinedName] <String> [[-AuthenticatorType] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns a registration challenge to begin enrolling a new U2F device for the current user. Pass the returned `Challenge` (and the request's `RpId`/`UserName`/etc.) to a browser's WebAuthn `navigator.credentials.create()` call, then submit its result via `Complete-IDUserU2FRegistrationChallenge`.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDUserU2FRegistrationChallenge -UserDefinedName 'My Security Key'
```

Returns a registration challenge for a new U2F device.

## PARAMETERS

### -UserDefinedName
A friendly name for the new device.

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

### -AuthenticatorType
The type of U2F authenticator being registered - 'SECURITYKEY' for a physical security key, or 'PASSKEY' for a passkey.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: SECURITYKEY
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
