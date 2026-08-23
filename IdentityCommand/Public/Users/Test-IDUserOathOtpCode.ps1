# .ExternalHelp IdentityCommand-help.xml
# TODO: DEPRIORITIZED - tested against a genuine, currently-valid OATH TOTP code
#  got back a generic "Exception occurred while performing action."
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

    begin {}#begin

    process {

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

    end {}#end

}
