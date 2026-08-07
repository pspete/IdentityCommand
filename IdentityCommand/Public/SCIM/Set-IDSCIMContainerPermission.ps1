# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Attributes is the full replacement SCIM ContainerPermissions resource document as a
# hashtable - see New-IDSCIMContainerPermission for the recorded field shape.
function Set-IDSCIMContainerPermission {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Attributes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Replace SCIM Container Permission')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'ContainerPermissions' -Method 'PUT' -ID $ID -Body $Attributes

        }

    }#process

    END {}#end

}
