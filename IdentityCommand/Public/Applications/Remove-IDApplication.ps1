# .ExternalHelp IdentityCommand-help.xml
function Remove-IDApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'AppKey')]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Remove Application')) {

            #Constructed body for the rest call
            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/DeleteApplication"
                'Method' = 'POST'
                'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
