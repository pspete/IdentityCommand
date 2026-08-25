# .ExternalHelp IdentityCommand-help.xml
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
