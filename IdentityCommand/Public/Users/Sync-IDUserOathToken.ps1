# .ExternalHelp IdentityCommand-help.xml
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
