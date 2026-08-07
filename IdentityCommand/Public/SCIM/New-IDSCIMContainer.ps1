# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Attributes is the full SCIM Container resource document as a hashtable, e.g.
# @{name='SomeSafe'; description='Some description'; 'urn:ietf:params:scim:schemas:cyberark:1.0:Safe'=@{NumberOfDaysRetention=7; ManagingCPM='PasswordManager'}; schemas=@('urn:ietf:params:scim:schemas:cyberark:1.0:Safe')}.
function New-IDSCIMContainer {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Attributes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess(($Attributes['name']), 'Create SCIM Container')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Containers' -Method 'POST' -Body $Attributes

        }

    }#process

    END {}#end

}
