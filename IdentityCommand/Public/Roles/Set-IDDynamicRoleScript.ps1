# Verified against a live tenant. Requires the role's actual ID/UUID/_RowKey, not its display
# name - added -ID as an explicit alias for discoverability (it was already aliased -Uuid). Also
# requires a role of -RoleType Script (New-IDRole) - a PrincipalList role does not support a
# dynamic membership script.
# Two more real bugs found and fixed live:
# 1. The body was hand-built via raw string interpolation with single-quoted values and no
#    escaping ("{'Name': '$Name', 'Script': '$Script'}"), which silently corrupts the JSON for any
#    real-world script (nearly all contain a literal ' character, e.g.
#    User.Properties.Properties['distinguishedName']). It only ever appeared to work with trivial
#    placeholder scripts like '...' or 'True' that happen to contain no quotes. Switched to
#    ConvertTo-Json, which escapes correctly.
# 2. Despite every sibling /Roles/* endpoint in this module (GetRole, GetRoleMembers, UpdateRole,
#    etc.) using "Name" as their literal JSON key even when a role ID/UUID value is required,
#    Roles/SetDynamicRoleScript specifically uses "ID" as its literal key - confirmed live by
#    testing both directly. Using "Name" (matching every other command) produced "Unexpected null
#    arguments passed to the server." even with a valid ID value and well-formed JSON; "ID" worked.
function Set-IDDynamicRoleScript {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid', 'ID')]
        $Name,

        [Parameter(Mandatory = $true)]
        [string]$Script

    )

    BEGIN {} #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, 'Set Dynamic Role Script')) {

            #Constructed body for the rest call - previously referenced an undeclared $User variable
            #(always empty, a copy-paste artifact from the similarly-shaped Test-IDDynamicRoleScript,
            #which legitimately takes a -User to preview a script's result for that user). This
            #command persists a script onto a role, so it needs the role's ID (the literal JSON key
            #is "ID", unlike every sibling /Roles/* command in this module which uses "Name" - see
            #header comment). Built via ConvertTo-Json (not raw string interpolation) so script
            #content containing quotes/newlines is escaped correctly.
            $body = ([ordered]@{
                'ID'     = $Name
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
