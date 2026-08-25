# .ExternalHelp IdentityCommand-help.xml
function Copy-IDApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Uuid', 'AppKey')]
        [String]$Key
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Key, 'Clone Application')) {

            #Constructed request for the rest call
            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/CloneAnApplicaton?$($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)"
                'Method' = 'POST'

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
