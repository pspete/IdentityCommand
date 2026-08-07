---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDTenantConfiguration

## SYNOPSIS
Set tenant custom configuration

## SYNTAX

```
Set-IDTenantConfiguration [-Settings] <Hashtable> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets custom configuration settings for the tenant, such as branding, login banners, and CORS settings.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDTenantConfiguration -Settings @{ CompanyName = 'Acme Corp'; ThemeColor = '#123456' }
```

Sets the tenant's company name and theme color.

## PARAMETERS

### -Settings
A hashtable of custom configuration settings to apply. Recognised keys include (but may not be limited to) CompanyName, ThemeColor, BackgroundColor, NavigationColor, LoginImage, LoginBackgroundImage, LoginBannerMessage, WelcomeMessage, PrivacyPolicyLink, TermsOfUseLink, AllowCors, ForgotUsernameAllowed, EnableQRCode, EnableUmc, OtpCodeLength, and reCaptchaThreshold.

```yaml
Type: Hashtable
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
