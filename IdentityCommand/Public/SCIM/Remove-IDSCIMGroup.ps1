# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
function Remove-IDSCIMGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Delete SCIM Group')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Groups' -Method 'DELETE' -ID $ID

        }

    }#process

    END {}#end

}
