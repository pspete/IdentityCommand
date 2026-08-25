# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
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
