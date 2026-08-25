# .ExternalHelp IdentityCommand-help.xml
function New-IDPassword {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'UserUuid')]
        [String]$ID,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Length = 0
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Generate Password')) {

            #Confirmed live via browser DevTools capture: the endpoint is lower-case
            #'generatepassword' (unlike the rest of this API's PascalCase paths), and both
            #'userUuid' and 'passwordLength' are required in the POST body - not a query string,
            #and there's no way to generate a tenant-wide password with no target user at all.
            $Body = @{

                'userUuid'       = $ID
                'passwordLength' = $Length

            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Core/generatepassword"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
