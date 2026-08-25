# .ExternalHelp IdentityCommand-help.xml
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

    begin {}#begin

    process {

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

    end {}#end

}
