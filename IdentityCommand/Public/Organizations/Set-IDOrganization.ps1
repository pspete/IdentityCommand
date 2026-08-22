# .ExternalHelp IdentityCommand-help.xml
function Set-IDOrganization {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$OrgId,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($OrgId, 'Update Organization')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Org/Update"
                'Method' = 'POST'
                'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
