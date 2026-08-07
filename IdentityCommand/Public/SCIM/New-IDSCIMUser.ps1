# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Attributes is the full SCIM User resource document as a hashtable, e.g.
# @{userName='someuser'; displayName='Some User'; active=$true; schemas=@('urn:ietf:params:scim:schemas:core:2.0:User')}.
# The recorded sample also shows optional nested 'name', 'emails', 'phoneNumbers', an
# 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User' extension, and a custom extension
# object - the exact required/optional fields for a given tenant are unconfirmed.
function New-IDSCIMUser {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Attributes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess(($Attributes['userName']), 'Create SCIM User')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Users' -Method 'POST' -Body $Attributes

        }

    }#process

    END {}#end

}
