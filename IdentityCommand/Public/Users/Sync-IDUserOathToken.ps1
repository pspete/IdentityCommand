# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
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

                'URI'    = "$($ISPSSSession.tenant_url)/Oath/ResychronizeOathToken"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
