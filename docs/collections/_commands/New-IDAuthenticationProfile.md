---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDAuthenticationProfile

## SYNOPSIS
Create a new authentication profile

## SYNTAX

```
New-IDAuthenticationProfile [-FirstFactorChallenges] <Object> [[-SecondFactorChallenges] <Object>]
 [[-AdditionalData] <Object>] [[-SingleChallengeMechanisms] <Object>] [[-DurationInMinutes] <Int32>]
 [-Name] <Object> [<CommonParameters>]
```

## DESCRIPTION
Create a new authentication profile - a named set of first and (optionally) second factor challenge mechanisms that can be referenced from an authentication policy to satisfy MFA.
If Security Question (SQ) is included as a challenge and -AdditionalData is not supplied, you are prompted interactively for the number of questions to ask.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDAuthenticationProfile -Name 'Password + OTP' -FirstFactorChallenges UP -SecondFactorChallenges OTP
```

Create a new authentication profile requiring a password followed by an OTP.

### Example 2
```powershell
PS C:\> New-IDAuthenticationProfile -Name 'QR Login' -FirstFactorChallenges QR -SingleChallengeMechanisms QR -DurationInMinutes 60
```

Create a new authentication profile that is satisfied by a single QR code scan, valid for 60 minutes.

## PARAMETERS

### -AdditionalData
A hashtable of additional settings required by the chosen challenges. For example, when Security Question (SQ) is one of the challenges, supply \`@{ NumberOfQuestions = <n> }\` to specify how many questions to ask. Defaults to an empty hashtable.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DurationInMinutes
The number of minutes a successful authentication against this profile remains valid before the challenges must be satisfied again. Defaults to 30.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstFactorChallenges
One or more challenge mechanisms to use as the first authentication factor, for example UP (password), OTP, OATH, SMS, EMAIL, QR, U2F, U2FONDEVICE, PASSKEY, SQ (security question) or RADIUS.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: OTP, PF, OATH, SMS, EMAIL, QR, U2F, U2FONDEVICE, PASSKEY, UP, SQ, RADIUS

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the new authentication profile.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondFactorChallenges
One or more challenge mechanisms to use as the second authentication factor. Optional; omit to require only a first factor.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: OTP, PF, OATH, SMS, EMAIL, QR, U2F, U2FONDEVICE, PASSKEY, UP, SQ, RADIUS

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SingleChallengeMechanisms
Specify QR or PASSKEY when a single mechanism should be sufficient to satisfy both the first and second factor in one step, instead of requiring them sequentially.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: QR, PASSKEY

Required: False
Position: 3
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
