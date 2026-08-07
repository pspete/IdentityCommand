# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Operations expects an array of SCIM PATCH operation hashtables, e.g.
# @(@{op='replace'; path='active'; value=$false}). -Schemas defaults to the standard SCIM PATCH
# schema URN if not supplied, matching the recorded sample's shape.
function Update-IDSCIMUser {
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

        if ($PSCmdlet.ShouldProcess($ID, 'Patch SCIM User')) {

            $Body = [ordered]@{
                'Operations' = $Operations
                'schemas'    = $Schemas
            }

            #Send Request
            Invoke-IDSCIMRequest -Resource 'Users' -Method 'PATCH' -ID $ID -Body $Body

        }

    }#process

    END {}#end

}
