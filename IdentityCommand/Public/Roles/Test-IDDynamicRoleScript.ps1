# TODO: Fixed a real bug found live while testing the sibling Set-IDDynamicRoleScript - the body
# was hand-built via raw string interpolation with single-quoted values and no escaping, which
# silently corrupts the JSON for any real-world script (nearly all contain a literal ' character,
# e.g. User.Properties.Properties['distinguishedName']). It only ever appeared to work with trivial
# placeholder scripts that happen to contain no quotes. Switched to ConvertTo-Json.
function Test-IDDynamicRoleScript {

    [CmdletBinding()]
	param
	(

        [Parameter(Mandatory = $true)]
        $User,

        [Parameter(Mandatory = $true)]
        [string]$Script

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call - built via ConvertTo-Json (not raw string
        #interpolation) so script content containing quotes/newlines is escaped correctly.
        $body = ([ordered]@{
            'User'   = $User
            'Script' = $Script
        } | ConvertTo-Json)

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "$($ISPSSSession.tenant_url)/Roles/TestDynamicRoleScript"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = $body
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    } #process

    END {} #end
}
