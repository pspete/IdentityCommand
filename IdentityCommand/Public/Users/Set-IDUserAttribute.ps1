# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The recorded sample body only showed CmaRedirectedUserUuid, ID, MobileNumber, and OrgPath -
# the full set of AD attributes this endpoint accepts is unconfirmed and may not be limited to
# these fields.
function Set-IDUserAttribute {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$MobileNumber,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$OrgPath,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$CmaRedirectedUserUuid
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Set User Attributes')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/ChangeUserAttributes"
                'Method' = 'POST'
                'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
