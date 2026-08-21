# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
# TODO: -Attributes is the full replacement SCIM User resource document as a hashtable - see
# New-IDSCIMUser for the recorded field shape. This performs a full PUT replace, not a partial
# update; use Update-IDSCIMUser for a PATCH-style partial update.
function Set-IDSCIMUser {
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

        if ($PSCmdlet.ShouldProcess($ID, 'Replace SCIM User')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Users' -Method 'PUT' -ID $ID -Body $Attributes

        }

    }#process

    END {}#end

}
