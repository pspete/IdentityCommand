# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The recorded Bruno sample calls this endpoint with a bearer token, but self-service signup
# flows are typically anonymous/pre-auth in practice - it is unconfirmed whether a real tenant
# requires an authenticated session here, or whether the token is a special signup-policy token.
# This command uses the current session ($ISPSSSession) like any other Public command; if signup
# actually needs to run pre-auth, it will need reworking similar to New-IDUsernameReminder.
function New-IDUserSignup {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$PrimaryIdentifier,

        [parameter(Mandatory = $true)]
        [SecureString]$Password,

        [parameter(Mandatory = $false)]
        [String]$DisplayName,

        [parameter(Mandatory = $false)]
        [String]$Name,

        [parameter(Mandatory = $false)]
        [String]$Mail,

        [parameter(Mandatory = $false)]
        [String]$Description,

        [parameter(Mandatory = $false)]
        [String]$HomeNumber,

        [parameter(Mandatory = $false)]
        [String]$OfficeNumber,

        [parameter(Mandatory = $false)]
        [String]$MobileNumber,

        [parameter(Mandatory = $false)]
        [Boolean]$VerifyEmail = $true,

        [parameter(Mandatory = $false)]
        [String]$ReCaptchaToken
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($PrimaryIdentifier, 'Signup External User')) {

            $Body = [ordered]@{
                'Password'          = ($Password | ConvertTo-InsecureString)
                'HomeNumber'        = $HomeNumber
                'PrimaryIdentifier' = $PrimaryIdentifier
                'DisplayName'       = $DisplayName
                'OfficeNumber'      = $OfficeNumber
                'MobileNumber'      = $MobileNumber
                'VerifyEmail'       = $VerifyEmail
                'Mail'              = $Mail
                'ReCaptchaToken'    = $ReCaptchaToken
                'Description'       = $Description
                'Name'              = $Name
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/User/Signup"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
