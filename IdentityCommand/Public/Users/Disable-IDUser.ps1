# .ExternalHelp IdentityCommand-help.xml
function Disable-IDUser {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Disable User')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/ChangeUserState"
                'Method' = 'POST'
                'Body'   = (@{ 'uuid' = $ID; 'state' = $false } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
