# .ExternalHelp IdentityCommand-help.xml
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
                #The underlying API parameter is named '_RowKey' (accepts the application's Name
                #or AppKey - per the vendor's own parameter docs it cannot be the Application Id
                #for OAuth/OIDC-type applications), passed as a query string with no JSON body.
                $Request['URI'] = "$($ISPSSSession.tenant_url)/SaasManage/GetApplication?_RowKey=$($ID | Get-EscapedString)"

                #Send Request
                Invoke-IDRestMethod @Request
            }
            'ServiceName' {
                #The underlying API parameter is named 'name', not 'ServiceName', per the vendor's
                #own parameter docs. This endpoint only returns the application's ID rather than
                #its full details, so chain into an ID lookup to return the same shape of result
                #as the ID parameter set does.
                $Request['URI'] = "$($ISPSSSession.tenant_url)/SaasManage/GetAppIDByServiceName?name=$($ServiceName | Get-EscapedString)"

                $AppID = Invoke-IDRestMethod @Request

                if ($null -ne $AppID) {

                    Get-IDApplication -ID $AppID

                }
            }
        }

    }#process

    END {}#end

}
