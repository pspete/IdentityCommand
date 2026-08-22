# .ExternalHelp IdentityCommand-help.xml
function Get-IDTenantSecurityQuestion {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ID'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN {
        $Request = @{}
        $Request['Method'] = 'POST'
    }#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {
            'All' {
                $Request['URI'] = "$($ISPSSSession.tenant_url)/TenantConfig/GetAdminSecurityQuestions"
            }
            'ID' {
                $Request['URI'] = "$($ISPSSSession.tenant_url)/TenantConfig/GetAdminSecurityQuestion"
                $Request['Body'] = (@{ 'Id' = $ID } | ConvertTo-Json)
            }
        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}
