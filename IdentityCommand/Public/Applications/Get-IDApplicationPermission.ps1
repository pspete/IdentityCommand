# .ExternalHelp IdentityCommand-help.xml
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

        if (-not $IncludeInherited) {

            $Result = $Result | Where-Object { -not $_.Inherited }

        }

        foreach ($Entry in $Result) {

            $Entry | Add-Member -NotePropertyName 'Rights' -NotePropertyValue @(ConvertFrom-IDApplicationPermissionGrant -Grant $Entry.Grant) -PassThru

        }

    }#process

    END {}#end

}
