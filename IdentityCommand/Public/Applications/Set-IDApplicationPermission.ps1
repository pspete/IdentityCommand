# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant. Confirmed 2026-08-21 via a browser DevTools capture of the admin
# portal's application permissions UI. The request body needs RowKey/PVID alongside ID (all three
# the same app key) and each Grants entry needs this full shape (not just Principal/PType/Rights
# as originally guessed) - exposed below as individual parameters (one grant per call, matching
# how the confirmed-working capture was itself a single-entry Grants array) rather than requiring
# callers to hand-build a hashtable:
#   @{
#       Principal            = '<user or role name, e.g. "someuser@tenant.cyberark.cloud.1234">'
#       PType                = 'User'   # or 'Role'
#       Rights               = 'View,Execute'   # comma-separated string, NOT an array - confirmed
#                                                # valid flag names: Grant, View, Admin, ViewDetail,
#                                                # Delete, Execute, Automatic ('Execute' is very
#                                                # likely the "run this app" right, not 'Run')
#       PrincipalId          = '<user/role UUID>'
#       DirectoryServiceUuid = '<from Get-IDUserAttribute>'
#       ExternalUuid         = '<user/role UUID - same as PrincipalId for a User>'
#       SystemName           = '<same as Principal>'
#       Type                 = 'User'   # or 'Role'
#   }
# -SystemName/-ExternalUuid/-Type default to -Principal/-PrincipalId/-PType respectively when not
# explicitly supplied, matching the confirmed live example where they were identical - override
# them if a real case ever needs them to diverge. Still unconfirmed: the -Revoke shape (no revoke
# request was captured), and whether Role-type entries need the same DirectoryServiceUuid/
# ExternalUuid fields as User-type ones.
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
