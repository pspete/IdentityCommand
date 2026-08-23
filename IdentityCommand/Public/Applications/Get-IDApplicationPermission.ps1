# .ExternalHelp IdentityCommand-help.xml
# TODO: The 'Grant'/'GrantStr' bitmask on each entry hasn't been decoded to the named rights
# Set-IDApplicationPermission uses (Grant/View/Admin/ViewDetail/Delete/Execute/Automatic) - a
# Set-IDApplicationPermission call with a single known right, followed by a Get-IDApplicationPermission
# against the same principal, would let that bit be identified.
function Get-IDApplicationPermission {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'AppKey')]
        [String]$ID,

        #Also return inherited entries (role-based/system admin grants not scoped to this
        #application) alongside this application's own direct grants
        [parameter(Mandatory = $false)]
        [Switch]$IncludeInherited
    )

    BEGIN {}#begin

    PROCESS {

        $Body = [ordered]@{
            'RowKey'         = $ID
            'Table'          = 'Application'
            'ReduceSysadmin' = $true
            'Args'           = [ordered]@{
                'PageNumber' = 1
                'PageSize'   = 100000
                'Limit'      = 100000
                'SortBy'     = ''
                'Caching'    = -1
            }
        }

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/Acl/GetRowAces"
            'Method' = 'POST'
            'Body'   = ($Body | ConvertTo-Json -Depth 6)

        }

        $Result = Invoke-IDRestMethod @Request

        if ($IncludeInherited) {

            $Result

        }
        else {

            $Result | Where-Object { -not $_.Inherited }

        }

    }#process

    END {}#end

}
