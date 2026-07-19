---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDAuthenticationAssuranceLevel

## SYNOPSIS
Get the MFA assurance level for a combination of authentication challenges

## SYNTAX

### NotFilled
```
Get-IDAuthenticationAssuranceLevel -FirstFactorChallenges <Object> [-SecondFactorChallenges <Object>]
 [<CommonParameters>]
```

### Prefilled
```
Get-IDAuthenticationAssuranceLevel -Challenges <Object> [<CommonParameters>]
```

## DESCRIPTION
Calculates the MFA assurance (scoring) level that CyberArk Identity assigns to a combination of first and second factor authentication challenges.
Build the combination from individual challenge mechanisms with -FirstFactorChallenges and -SecondFactorChallenges, or pass an already-built two-element -Challenges array (for example the \`Challenges\` property returned by \`Get-IDAuthenticationProfile\`).

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDAuthenticationAssuranceLevel -FirstFactorChallenges UP -SecondFactorChallenges OTP
```

Return the assurance level for a password (UP) first factor combined with an OTP second factor.

### Example 2
```powershell
PS C:\> Get-IDAuthenticationProfile -Name 1234-abcd-5678-efgh | Get-IDAuthenticationAssuranceLevel
```

Return the assurance level for the challenge combination configured on the matching authentication profile.

## PARAMETERS

### -Challenges
A pre-built two-element array of challenge mechanisms (first factor, second factor) to score, such as the \`Challenges\` property returned by \`Get-IDAuthenticationProfile\`.

```yaml
Type: Object
Parameter Sets: Prefilled
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FirstFactorChallenges
One or more challenge mechanisms to use as the first authentication factor, for example UP (password), OTP, OATH, SMS, EMAIL, QR, U2F, U2FONDEVICE, PASSKEY, SQ (security question) or RADIUS.

```yaml
Type: Object
Parameter Sets: NotFilled
Aliases:
Accepted values: OTP, PF, OATH, SMS, EMAIL, QR, U2F, U2FONDEVICE, PASSKEY, UP, SQ, RADIUS

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondFactorChallenges
One or more challenge mechanisms to use as the second authentication factor. Optional; omit to score the first factor challenge(s) alone.

```yaml
Type: Object
Parameter Sets: NotFilled
Aliases:
Accepted values: OTP, PF, OATH, SMS, EMAIL, QR, U2F, U2FONDEVICE, PASSKEY, UP, SQ, RADIUS

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
