# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant - with a real fix. The originally guessed body shape
# ({"Name":..., "TemplateName":...}) was silently accepted by the server (success:true) but never
# actually created an application (empty Result) - it doesn't match any field the endpoint
# recognizes. The confirmed shape, matching Import-IDApplicationTemplate (which hits the same
# SaasManage/ImportAppFromTemplate endpoint), is {"ID": [<template ID>]} - a template's ID is the
# same value as its Name (see Get-IDApplicationTemplate). There is no way to rename the app at
# creation time; the endpoint always uses the template's own name. Use Set-IDApplication afterward
# to rename if needed.
function New-IDApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('ID')]
        [String]$TemplateName
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($TemplateName, 'Import Application From Template')) {

            #Constructed body for the rest call
            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/ImportAppFromTemplate"
                'Method' = 'POST'
                'Body'   = (@{ 'ID' = @($TemplateName) } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
