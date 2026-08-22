# .ExternalHelp IdentityCommand-help.xml
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
