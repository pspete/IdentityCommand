# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Attributes is the full SCIM Group resource document as a hashtable, e.g.
# @{displayName='Some Group'; members=@(@{value='someuserid'}); schemas=@('urn:ietf:params:scim:schemas:core:2.0:Group')}.
function New-IDSCIMGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Attributes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess(($Attributes['displayName']), 'Create SCIM Group')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Groups' -Method 'POST' -Body $Attributes

        }

    }#process

    END {}#end

}
