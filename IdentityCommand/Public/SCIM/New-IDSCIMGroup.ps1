# .ExternalHelp IdentityCommand-help.xml
function New-IDSCIMGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Attributes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess(($Attributes['displayName']), 'Create SCIM Group')) {

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Groups' -Method 'POST' -Body $Attributes

        }

    }#process

    END {}#end

}
