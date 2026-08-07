# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Attributes is the full SCIM ContainerPermissions resource document as a hashtable, e.g.
# @{container=@{value='somesafeid'}; user=@{value='someuserid'}; rights=@('ListContent','AddContent'); schemas=@('urn:ietf:params:scim:schemas:cyberark:1.0:SafeMember')}.
function New-IDSCIMContainerPermission {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Attributes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess('SCIM Container Permission', 'Create')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'ContainerPermissions' -Method 'POST' -Body $Attributes

        }

    }#process

    END {}#end

}
