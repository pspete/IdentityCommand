# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: Valid values for -TemplateType are not documented anywhere in the sources checked (likely
# something like 'Email'/'SMS', by analogy with other notification-template APIs, but unconfirmed).
function Get-IDTenantMessageTemplate {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Named'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$TemplateName,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Named'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$TemplateType
    )

    BEGIN {
        $Request = @{}
        $Request['Method'] = 'POST'
    }#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {
            'All' {
                $Request['URI'] = "$($ISPSSSession.tenant_url)/TenantConfig/GetEditableMessageTemplates"
            }
            'Named' {
                $Request['URI'] = "$($ISPSSSession.tenant_url)/TenantConfig/GetEditableMessageTemplate?templateName=$($TemplateName | Get-EscapedString)&templateType=$($TemplateType | Get-EscapedString)"
            }
        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}
