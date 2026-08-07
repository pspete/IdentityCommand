# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Attributes is the full SCIM PrivilegedData resource document as a hashtable, e.g.
# @{name='SomeAccount'; description='Some description'; type='sometype'; 'urn:ietf:params:scim:schemas:cyberark:1.0:PrivilegedData'=@{safe='SomeSafe'; properties=@(@{key='someproperty'; value='somevalue'})}; schemas=@('urn:ietf:params:scim:schemas:cyberark:1.0:PrivilegedData')}.
function New-IDSCIMPrivilegedData {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Attributes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess(($Attributes['name']), 'Create SCIM Privileged Data')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'PrivilegedData' -Method 'POST' -Body $Attributes

        }

    }#process

    END {}#end

}
