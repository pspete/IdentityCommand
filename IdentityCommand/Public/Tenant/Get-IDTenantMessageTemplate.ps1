# .ExternalHelp IdentityCommand-help.xml
# TODO: Valid values for -TemplateType are not documented anywhere in the sources checked (likely
# something like 'Email'/'SMS', by analogy with other notification-template APIs, but unconfirmed).
# TODO: -Named set (GetEditableMessageTemplate, singular) is still unverified against a live
# tenant - its response shape may or may not need the same Results.Row flattening as the -All set.
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
        $result = Invoke-IDRestMethod @Request

        if ($PSCmdlet.ParameterSetName -eq 'All') {

            #GetEditableMessageTemplates returns a RedRock-style query envelope - flatten to the
            #actual template rows, matching the convention used by Get-IDRole/Get-IDApplicationTemplate
            $result.Results.Row

        } else {

            $result

        }

    }#process

    END {}#end

}
