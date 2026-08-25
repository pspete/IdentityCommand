# .ExternalHelp IdentityCommand-help.xml
function Set-IDApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'AppKey')]
        [String]$ID,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Update Application')) {

            #_RowKey/PVID are required alongside ID, all three set to the same application key -
            #a bare 'ID' alone fails with "The provided RowKey  is not valid.". Get-IDApplication
            #separately confirmed the underlying API parameter for this value is literally
            #'_RowKey' (underscore-prefixed) rather than 'RowKey'.
            $Body = $PSBoundParameters | Get-Parameter
            $Body['_RowKey'] = $ID
            $Body['PVID'] = $ID

            #Constructed body for the rest call
            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/UpdateApplicationDE"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request - the response is just {State: 0}, not the updated application. Only
            #State 0 is confirmed as success, so only fetch the updated application in that case -
            #otherwise return the raw result rather than masking a non-zero State
            $Result = Invoke-IDRestMethod @Request

            if ($Result.State -eq 0) {

                Get-IDApplication -ID $ID

            } else {

                $Result

            }

        }

    }#process

    END {}#end

}
