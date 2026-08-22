# .ExternalHelp IdentityCommand-help.xml
# TODO: -Attributes is the full replacement SCIM Group resource document as a hashtable - see
# New-IDSCIMGroup for the recorded field shape. This performs a full PUT replace, not a partial
# update; use Update-IDSCIMGroup for a PATCH-style partial update.
function Set-IDSCIMGroup {
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

        if ($PSCmdlet.ShouldProcess($ID, 'Replace SCIM Group')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Groups' -Method 'PUT' -ID $ID -Body $Attributes

        }

    }#process

    END {}#end

}
