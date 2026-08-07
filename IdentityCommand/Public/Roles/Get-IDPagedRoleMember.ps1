####
#### This will not return a result, and only reports back that it cant find the roles defined
function Get-IDPagedRoleMember {

    [CmdletBinding()]
    param
    (

        [Parameter(Mandatory = $true)]
        [Alias('Uuid')]
        $Name,

        [Parameter(Mandatory = $false)]
        $FilterValue = '',

        [Parameter(Mandatory = $false)]
        [array]$FilterBy = @(),

        [Parameter(Mandatory = $false)]
        $PageNumber = 1,

        [Parameter(Mandatory = $false)]
        [bool]$Ascending = $true,

        [Parameter(Mandatory = $false)]
        $PageSize = 100,

        [Parameter(Mandatory = $false)]
        $SortBy = 'Name'

    )

    begin {} #begin

    process {

        #Constructed body for the rest call
        $body = [ordered]@{

            'Name'        = $Name
            'SortBy'      = $SortBy
            'PageNumber'  = $PageNumber
            'Ascending'   = $Ascending
            'FilterBy'    = $FilterBy
            'PageSize'    = $PageSize
            'FilterValue' = $FilterValue

        }

        #Constructed parameters for the rest call
        $RestCall = @{

            'URI'         = "$($ISPSSSession.tenant_url)/Roles/GetPagedRoleMembers"
            'Headers'     = $($ISPSSSession.WebSession.Headers)
            'Method'      = 'Post'
            'Body'        = ($body | ConvertTo-Json -Depth 6)
            'ContentType' = 'application/json'

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    } #process

    end {} #end
}
