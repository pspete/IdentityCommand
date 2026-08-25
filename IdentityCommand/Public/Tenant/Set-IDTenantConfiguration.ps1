# .ExternalHelp IdentityCommand-help.xml
function Set-IDTenantConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $false)]
        [Int]$OtpCodeLength,

        [parameter(Mandatory = $false)]
        [Bool]$TenantUrlDeprecationEnabled,

        [parameter(Mandatory = $false)]
        [String]$Icon,

        [parameter(Mandatory = $false)]
        [Bool]$EnableUmc,

        [parameter(Mandatory = $false)]
        [Bool]$SendPasswordChangeConfirmation,

        [parameter(Mandatory = $false)]
        [String]$LoginBannerMessage,

        [parameter(Mandatory = $false)]
        [Bool]$StoreCorporateAppUserCredsInVault,

        [parameter(Mandatory = $false)]
        [String]$LoginSampleText,

        [parameter(Mandatory = $false)]
        [String]$PortalImage,

        [parameter(Mandatory = $false)]
        [Bool]$LoginBannerMessageL10nEnabled,

        [parameter(Mandatory = $false)]
        [String]$CompanySupportLink,

        [parameter(Mandatory = $false)]
        [String]$ThemeColor,

        [parameter(Mandatory = $false)]
        [String]$GlobalImage,

        [parameter(Mandatory = $false)]
        [Int]$ZsoCertLifeTime,

        [parameter(Mandatory = $false)]
        [Hashtable[]]$MfaAttributeMapping,

        [parameter(Mandatory = $false)]
        [String]$LoginBackgroundImage,

        [parameter(Mandatory = $false)]
        [Bool]$StorePersonalAppUserCredsInVault,

        [parameter(Mandatory = $false)]
        [String]$CompanyName,

        [parameter(Mandatory = $false)]
        [Bool]$IsOriginValidationEnabled,

        [parameter(Mandatory = $false)]
        [Int]$reCaptchaThreshold,

        [parameter(Mandatory = $false)]
        [String]$WelcomeMessage,

        [parameter(Mandatory = $false)]
        [Int]$ZsoCertRenewalWindow,

        [parameter(Mandatory = $false)]
        [String]$EmailImage,

        [parameter(Mandatory = $false)]
        [String]$LoginImage,

        [parameter(Mandatory = $false)]
        [Bool]$IsOriginValidationOnGetEnabled,

        [parameter(Mandatory = $false)]
        [Bool]$ForgotUsernameAllowed,

        [parameter(Mandatory = $false)]
        [String]$NavigationColor,

        [parameter(Mandatory = $false)]
        [Bool]$IsPasswordPersistanceEnabled,

        [parameter(Mandatory = $false)]
        [String[]]$FastSearchEnabledEntities,

        [parameter(Mandatory = $false)]
        [String]$PrivacyPolicyLink,

        [parameter(Mandatory = $false)]
        [String[]]$AllowCors,

        [parameter(Mandatory = $false)]
        [String]$BackgroundColor,

        [parameter(Mandatory = $false)]
        [Bool]$EnableQRCode,

        [parameter(Mandatory = $false)]
        [String]$CustomerCompany,

        [parameter(Mandatory = $false)]
        [Bool]$DisplayLoginBanner,

        [parameter(Mandatory = $false)]
        [String]$TermsOfUseLink,

        #Catch-all for settings without a named parameter, merged in as literal API field names
        [parameter(Mandatory = $false)]
        [Hashtable]$AdditionalSettings
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ISPSSSession.tenant_url, 'Set Tenant Custom Configuration')) {

            $Settings = $PSBoundParameters | Get-Parameter -ParametersToRemove AdditionalSettings

            if ($PSBoundParameters.ContainsKey('AdditionalSettings')) {

                foreach ($Key in $AdditionalSettings.Keys) { $Settings[$Key] = $AdditionalSettings[$Key] }

            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/TenantConfig/SetCustomerConfig"
                'Method' = 'POST'
                'Body'   = ($Settings | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
