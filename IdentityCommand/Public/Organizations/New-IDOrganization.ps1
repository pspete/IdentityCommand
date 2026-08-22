# .ExternalHelp IdentityCommand-help.xml
# TODO: Org/Create returns an object with ID/Name/Description/Path - the new organization's key
# is under .ID, not .OrgId.
function New-IDOrganization {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, 'Create Organization')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Org/Create"
                'Method' = 'POST'
                'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
