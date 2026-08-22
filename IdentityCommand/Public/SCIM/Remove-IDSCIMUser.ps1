# .ExternalHelp IdentityCommand-help.xml
function Remove-IDSCIMUser {
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

        if ($PSCmdlet.ShouldProcess($ID, 'Delete SCIM User')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Users' -Method 'DELETE' -ID $ID

        }

    }#process

    END {}#end

}
