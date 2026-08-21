# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: Live-tested 2026-08-21 - the URL had a typo (Oath/ResychronizeOathToken, missing the 'n'
# from "Resynchronize") which 404'd. Fixed to Oath/ResynchronizeOathToken. Still needs live
# re-verification with a real enrolled OATH token/codes to confirm the corrected URL and body
# shape actually succeed end-to-end.
function Sync-IDUserOathToken {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$TokenId,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$FirstCode,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SecondCode
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($TokenId, 'Resynchronize OATH Token')) {

            $Body = [ordered]@{
                'firstCode'  = $FirstCode
                'secondCode' = $SecondCode
                'tokenId'    = $TokenId
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Oath/ResynchronizeOathToken"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
