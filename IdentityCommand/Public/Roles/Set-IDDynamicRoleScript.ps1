# .ExternalHelp IdentityCommand-help.xml
function Set-IDDynamicRoleScript {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $ID,

        [Parameter(Mandatory = $true)]
        [string]$Script

    )

    BEGIN {} #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Set Dynamic Role Script')) {

            #Constructed body for the rest call - previously referenced an undeclared $User variable
            #(always empty, a copy-paste artifact from the similarly-shaped Test-IDDynamicRoleScript,
            #which legitimately takes a -User to preview a script's result for that user). This
            #command persists a script onto a role, so it needs the role's ID (the literal JSON key
            #is "ID", unlike every sibling /Roles/* command in this module which uses "Name" - see
            #header comment). Built via ConvertTo-Json (not raw string interpolation) so script
            #content containing quotes/newlines is escaped correctly.
            $body = ([ordered]@{
                'ID'     = $ID
                'Script' = $Script
            } | ConvertTo-Json)

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/Roles/SetDynamicRoleScript"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = $body
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    } #process

    END {} #end
}
