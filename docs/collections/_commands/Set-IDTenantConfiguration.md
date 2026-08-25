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
Set-IDTenantConfiguration [-OtpCodeLength <Int32>] [-TenantUrlDeprecationEnabled <Boolean>] [-Icon <String>]
 [-EnableUmc <Boolean>] [-SendPasswordChangeConfirmation <Boolean>] [-LoginBannerMessage <String>]
 [-StoreCorporateAppUserCredsInVault <Boolean>] [-LoginSampleText <String>] [-PortalImage <String>]
 [-LoginBannerMessageL10nEnabled <Boolean>] [-CompanySupportLink <String>] [-ThemeColor <String>]
 [-GlobalImage <String>] [-ZsoCertLifeTime <Int32>] [-MfaAttributeMapping <Hashtable[]>]
 [-LoginBackgroundImage <String>] [-StorePersonalAppUserCredsInVault <Boolean>] [-CompanyName <String>]
 [-IsOriginValidationEnabled <Boolean>] [-reCaptchaThreshold <Int32>] [-WelcomeMessage <String>]
 [-ZsoCertRenewalWindow <Int32>] [-EmailImage <String>] [-LoginImage <String>]
 [-IsOriginValidationOnGetEnabled <Boolean>] [-ForgotUsernameAllowed <Boolean>] [-NavigationColor <String>]
 [-IsPasswordPersistanceEnabled <Boolean>] [-FastSearchEnabledEntities <String[]>] [-PrivacyPolicyLink <String>]
 [-AllowCors <String[]>] [-BackgroundColor <String>] [-EnableQRCode <Boolean>] [-CustomerCompany <String>]
 [-DisplayLoginBanner <Boolean>] [-TermsOfUseLink <String>] [-AdditionalSettings <Hashtable>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets custom configuration settings for the tenant, such as branding, login page text, and security options.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDTenantConfiguration -CompanyName 'Acme Corp' -CompanySupportLink 'https://acme.example.com/support'
```

Sets the tenant's company name and support link.

### Example 2
```powershell
PS C:\> Set-IDTenantConfiguration -AdditionalSettings @{ 'SomeUndocumentedField' = 'SomeValue' }
```

Sets a field that has no dedicated parameter, using its literal API field name.

## PARAMETERS

### -OtpCodeLength
The length of one-time-passcodes.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantUrlDeprecationEnabled
Whether the deprecated tenant URL form is enabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Icon
The tenant's icon/favicon.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableUmc
Whether Unified Mobile Client support is enabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SendPasswordChangeConfirmation
Whether a confirmation is sent when a password is changed.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginBannerMessage
The login banner message text.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StoreCorporateAppUserCredsInVault
Whether corporate app user credentials are stored in the vault.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginSampleText
Sample/placeholder text shown in the login username field.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalImage
The portal's logo image.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginBannerMessageL10nEnabled
Whether the login banner message supports localization.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanySupportLink
The support URL (labelled "Support URL" in the admin portal).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThemeColor
The portal's theme color.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GlobalImage
A global branding image.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ZsoCertLifeTime
The lifetime of zero sign-on certificates.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MfaAttributeMapping
An array of MFA attribute mapping objects. The exact shape is undocumented.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginBackgroundImage
The background image shown on the login page.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StorePersonalAppUserCredsInVault
Whether personal app user credentials are stored in the vault.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyName
The company name shown in the portal.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsOriginValidationEnabled
Whether request origin validation is enabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -reCaptchaThreshold
The reCAPTCHA score threshold.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WelcomeMessage
The welcome message text.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ZsoCertRenewalWindow
The renewal window for zero sign-on certificates.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailImage
The image used in outgoing emails.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginImage
The image shown on the login page.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsOriginValidationOnGetEnabled
Whether request origin validation is enabled for GET requests.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForgotUsernameAllowed
Whether the "forgot username" self-service flow is allowed.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NavigationColor
The navigation bar color.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsPasswordPersistanceEnabled
Whether password persistence is enabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FastSearchEnabledEntities
An array of entity types with fast search enabled.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivacyPolicyLink
The privacy policy link URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowCors
An array of origins allowed for CORS.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundColor
The portal's background color.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableQRCode
Whether QR code login is enabled.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomerCompany
The customer company name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayLoginBanner
Whether to display the login banner message.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TermsOfUseLink
The terms-of-use link URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdditionalSettings
A hashtable of additional settings without a dedicated parameter, keyed by their literal API field name - merged in alongside the named parameters above.

```yaml
Type: Hashtable
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
