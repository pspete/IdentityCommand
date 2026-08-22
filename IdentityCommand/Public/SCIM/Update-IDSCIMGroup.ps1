# .ExternalHelp IdentityCommand-help.xml
# TODO: -Operations expects an array of SCIM PATCH operation hashtables, e.g.
# @(@{op='add'; path='members'; value=@(@{value='someuserid'})}). -Schemas defaults to the standard
# SCIM PATCH schema URN if not supplied, matching the recorded sample's shape.
function Update-IDSCIMGroup {
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
        [Array]$Operations,

        [parameter(Mandatory = $false)]
        [Array]$Schemas = @('urn:ietf:params:scim:api:messages:2.0:PatchOp')
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Patch SCIM Group')) {

            $Body = [ordered]@{
                'Operations' = $Operations
                'schemas'    = $Schemas
            }

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Groups' -Method 'PATCH' -ID $ID -Body $Body

        }

    }#process

    END {}#end

}
