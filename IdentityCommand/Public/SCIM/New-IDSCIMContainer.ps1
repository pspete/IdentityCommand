# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
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
