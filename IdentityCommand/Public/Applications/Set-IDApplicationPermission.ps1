# .ExternalHelp IdentityCommand-help.xml
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

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Principal,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet('User', 'Role')]
        [String]$PType,

        [parameter(Mandatory = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$PrincipalId,

        #One boolean per confirmed right, so a permission set can be fed in from a CSV row or any
        #object with matching property names. All $false revokes (sends Rights of None), since the
        #API always expects the principal's complete right set for this application, not a delta
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [Bool]$Grant,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [Bool]$View,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [Bool]$Admin,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [Bool]$ViewDetail,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [Bool]$Delete,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [Bool]$Execute,

        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [Bool]$Automatic,

        #Baseline right set. Defaults to the principal's current grant, fetched via
        #Get-IDApplicationPermission - pass this explicitly to skip that lookup
        [parameter(Mandatory = $false, ValueFromPipelinebyPropertyName = $true)]
        [String[]]$Rights,

        [parameter(Mandatory = $false)]
        [String]$DirectoryServiceUuid = '',

        #Only sent for a User -PType - a live Role capture confirmed Role grants don't carry this
        [parameter(Mandatory = $false)]
        [String]$ExternalUuid,

        #Only sent for a User -PType - a live Role capture confirmed Role grants don't carry this
        [parameter(Mandatory = $false)]
        [String]$SystemName,

        [parameter(Mandatory = $false)]
        [ValidateSet('User', 'Role')]
        [String]$Type
    )

    BEGIN {}#begin

    PROCESS {

        #Baseline defaults to the principal's current grant on this application unless -Rights was
        #supplied explicitly - matched by PrincipalId, since Principal (the display name) isn't
        #guaranteed unique
        $Baseline = if ($PSBoundParameters.ContainsKey('Rights')) {

            $Rights

        }
        else {

            (Get-IDApplicationPermission -ID $ID | Where-Object { $_.Principal -eq $PrincipalId }).Rights

        }

        #Each right defaults to its presence in the baseline unless explicitly overridden by its
        #own switch, so a single right can be changed without resupplying the whole set
        $RightNames = foreach ($Name in 'Grant', 'View', 'Admin', 'ViewDetail', 'Delete', 'Execute', 'Automatic') {

            $Included = if ($PSBoundParameters.ContainsKey($Name)) { Get-Variable -Name $Name -ValueOnly } else { $Baseline -contains $Name }
            if ($Included) { $Name }

        }
        $RightsString = if ($RightNames) { $RightNames -join ',' } else { 'None' }
        $Action = if ($RightNames) { 'Set' } else { 'Revoke' }

        if ($PSCmdlet.ShouldProcess($ID, "$Action Application Permission for '$Principal'")) {

            if (-not $PSBoundParameters.ContainsKey('Type')) {

                $Type = $PType

            }

            $GrantEntry = [ordered]@{
                'Principal'            = $Principal
                'PType'                = $PType
                'Rights'               = $RightsString
                'PrincipalId'          = $PrincipalId
                'DirectoryServiceUuid' = $DirectoryServiceUuid
                'Type'                 = $Type
            }

            #SystemName/ExternalUuid default to Principal/PrincipalId when not explicitly supplied
            #- confirmed live for a User grant; a Role grant doesn't carry these fields at all
            if ($PType -eq 'User') {

                $GrantEntry['ExternalUuid'] = if ($PSBoundParameters.ContainsKey('ExternalUuid')) { $ExternalUuid } else { $PrincipalId }
                $GrantEntry['SystemName'] = if ($PSBoundParameters.ContainsKey('SystemName')) { $SystemName } else { $Principal }

            }

            #Constructed body for the rest call - RowKey/PVID confirmed required alongside ID via
            #a live DevTools capture, all three set to the same application key
            $Body = [ordered]@{
                'ID'     = $ID
                'RowKey' = $ID
                'PVID'   = $ID
                'Grants' = @($GrantEntry)
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
