# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The recorded sample request for this operation was mislabeled in its source (its URL
# pointed at Security/GetQRCodeStatus, clearly wrong given a body of {"ID":..., "phonepin":...}).
# The URL used here (/UserMgmt/SetPhonePin) is taken from the API's documented operation path
# instead, but has not itself been confirmed against a live tenant - only the body shape is trusted
# from the (mislabeled) sample.
function Set-IDUserPhonePin {
    [CmdletBinding(SupportsShouldProcess)]
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
        [String]$PhonePin
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Set User Phone PIN')) {

            $Body = [ordered]@{
                'ID'       = $ID
                'phonepin' = $PhonePin
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/SetPhonePin"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
