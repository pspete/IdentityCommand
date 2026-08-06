# .ExternalHelp IdentityCommand-help.xml
# TODO: Request body field ('ID'/'ServiceName') and the response object structure are inferred
# from the SaaS Manage API spec's operation summaries only - no full schema was available.
# Verify against a live tenant and adjust body key names / output shape as needed.
function Get-IDApplication {
    [CmdletBinding(DefaultParameterSetName = 'ID')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ID'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'AppKey')]
        [String]$ID,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ServiceName'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceName
    )

    BEGIN {
        $Request = @{}
        $Request['Method'] = 'POST'
    }#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {
            'ID' {
                $Request['URI'] = "$($ISPSSSession.tenant_url)/SaasManage/GetApplication"
            }
            'ServiceName' {
                $Request['URI'] = "$($ISPSSSession.tenant_url)/SaasManage/GetAppIDByServiceName"
            }
        }

        $Request['Body'] = $PSBoundParameters | Get-Parameter | ConvertTo-Json

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}
