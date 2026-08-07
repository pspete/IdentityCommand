# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: Valid values for -UseOathDefaults are not documented anywhere in the sources checked (likely
# a boolean-as-string, but unconfirmed).
function Test-IDUserOathOtpCode {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$OtpCode,

        [parameter(Mandatory = $false)]
        [String]$UseOathDefaults
    )

    BEGIN {}#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/Oath/ValidateOtpCode`?otpCode=$($OtpCode | Get-EscapedString)&uuid=$($ID | Get-EscapedString)"

        if ($PSBoundParameters.ContainsKey('UseOathDefaults')) {

            $URI = "$URI&useOathDefaults=$($UseOathDefaults | Get-EscapedString)"

        }

        $Request = @{

            'URI'    = $URI
            'Method' = 'POST'

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}
