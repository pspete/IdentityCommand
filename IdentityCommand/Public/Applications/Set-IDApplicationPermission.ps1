# .ExternalHelp IdentityCommand-help.xml
# TODO: -Revoke's shape is unconfirmed (no revoke request was captured). It's also unconfirmed
# whether Role-type Grants entries need the same DirectoryServiceUuid/ExternalUuid fields as
# User-type ones.
function Set-IDApplicationPermission {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'AppKey')]
        [String]$ID,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Principal,

        [parameter(Mandatory = $true)]
        [ValidateSet('User', 'Role')]
        [String]$PType,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Rights,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$PrincipalId,

        [parameter(Mandatory = $false)]
        [String]$DirectoryServiceUuid = '',

        [parameter(Mandatory = $false)]
        [String]$ExternalUuid,

        [parameter(Mandatory = $false)]
        [String]$SystemName,

        [parameter(Mandatory = $false)]
        [ValidateSet('User', 'Role')]
        [String]$Type
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, "Set Application Permission for '$Principal'")) {

            #SystemName/ExternalUuid/Type default to Principal/PrincipalId/PType when not
            #explicitly supplied - matches the confirmed live example, where they were identical
            if (-not $PSBoundParameters.ContainsKey('SystemName')) {

                $SystemName = $Principal

            }

            if (-not $PSBoundParameters.ContainsKey('ExternalUuid')) {

                $ExternalUuid = $PrincipalId

            }

            if (-not $PSBoundParameters.ContainsKey('Type')) {

                $Type = $PType

            }

            $Grant = [ordered]@{
                'Principal'            = $Principal
                'PType'                = $PType
                'Rights'               = ($Rights -join ',')
                'PrincipalId'          = $PrincipalId
                'DirectoryServiceUuid' = $DirectoryServiceUuid
                'ExternalUuid'         = $ExternalUuid
                'SystemName'           = $SystemName
                'Type'                 = $Type
            }

            #Constructed body for the rest call - RowKey/PVID confirmed required alongside ID via
            #a live DevTools capture, all three set to the same application key
            $Body = [ordered]@{
                'ID'     = $ID
                'RowKey' = $ID
                'PVID'   = $ID
                'Grants' = @($Grant)
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/SetApplicationPermissions"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
