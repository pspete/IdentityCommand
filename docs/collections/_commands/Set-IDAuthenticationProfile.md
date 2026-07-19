---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDAuthenticationProfile

## SYNOPSIS
Update an existing authentication profile

## SYNTAX

### NotFilled
```
Set-IDAuthenticationProfile -Uuid <Object> [-FirstFactorChallenges <Object>] [-SecondFactorChallenges <Object>]
 [-AdditionalData <Object>] [-SingleChallengeMechanisms <Object>] [-DurationInMinutes <Int32>] [-Name <Object>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Prefilled
```
Set-IDAuthenticationProfile -Uuid <Object> [-AdditionalData <Object>] [-SingleChallengeMechanisms <Object>]
 [-DurationInMinutes <Int32>] [-Name <Object>] [-Challenges <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update an existing authentication profile identified by -Uuid.
Build the updated first/second factor challenge combination with -FirstFactorChallenges and -SecondFactorChallenges, or pass an already-built -Challenges array directly.
If Security Question (SQ) is included as a challenge and -AdditionalData is not supplied, you are prompted interactively for the number of questions to ask.

## EXAMPLES

### Example 1
```
PS C:\> Set-IDAuthenticationProfile -Uuid 1234-abcd-5678-efgh -FirstFactorChallenges UP -SecondFactorChallenges OATH
```

Update the challenge combination of the matching authentication profile to a password followed by an OATH OTP.

### Example 2
```
PS C:\> Get-IDAuthenticationProfile -Name 1234-abcd-5678-efgh | Set-IDAuthenticationProfile -DurationInMinutes 60
```

Update the duration of the matching authentication profile, reusing its existing challenge combination via the pipeline.

## PARAMETERS

### -AdditionalData
A hashtable of additional settings required by the chosen challenges.
For example, when Security Question (SQ) is one of the challenges, supply \`@{ NumberOfQuestions = \<n\> }\` to specify how many questions to ask.
Defaults to an empty hashtable.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Challenges
A pre-built two-element array of challenge mechanisms (first factor, second factor) to set on the profile, such as the \`Challenges\` property returned by \`Get-IDAuthenticationProfile\`.

```yaml
Type: Object
Parameter Sets: Prefilled
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DurationInMinutes
The number of minutes a successful authentication against this profile remains valid before the challenges must be satisfied again.
Defaults to 30.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
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

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The (new) name of the authentication profile.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SecondFactorChallenges
One or more challenge mechanisms to use as the second authentication factor.
Optional; omit to require only a first factor.

```yaml
Type: Object
Parameter Sets: NotFilled
Aliases:
Accepted values: OTP, PF, OATH, SMS, EMAIL, QR, U2F, U2FONDEVICE, PASSKEY, UP, SQ, RADIUS

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SingleChallengeMechanisms
Specify QR or PASSKEY when a single mechanism should be sufficient to satisfy both the first and second factor in one step, instead of requiring them sequentially.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: , QR, PASSKEY

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Uuid
The unique ID of the authentication profile to update.

```yaml
Type: Object
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

### System.Object
### System.Int32
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
