# .ExternalHelp IdentityCommand-help.xml
function Get-IDWorkflowJob {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Mine', Justification = 'Used only to select the ParameterSetName')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ParameterSetName = 'JobId',
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$JobId,

        [parameter(
            Mandatory = $false,
            ParameterSetName = 'Mine'
        )]
        [Switch]$Mine,

        [parameter(Mandatory = $false)]
        [ValidateSet('all', 'approve', 'request')]
        [String]$Type = 'all',

        [parameter(Mandatory = $false)]
        [Int]$PageNumber = 1,

        [parameter(Mandatory = $false)]
        [Int]$PageSize = 100
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ParameterSetName -eq 'JobId') {

            #Fetch a single job - returned flat, no Results.Row wrapper to unwrap
            $Body = [ordered]@{
                'jobid'    = $JobId
                'RRFormat' = $true
                'Args'     = [ordered]@{
                    'PageNumber' = 1
                    'Limit'      = 1
                    'PageSize'   = 1
                    'Caching'    = -1
                }
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/JobFlow/GetJob"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

            return

        }

        switch ($PSCmdlet.ParameterSetName) {
            'Mine' {

                $URI = "$($ISPSSSession.tenant_url)/JobFlow/GetMyJobs"

            }
            'All' {

                if ($Type -ne 'all') {

                    $PSCmdlet.ThrowTerminatingError(

                        [System.Management.Automation.ErrorRecord]::new(

                            "-Type '$Type' is only valid with -Mine - the tenant-wide endpoint only supports 'all'.",
                            'InvalidType',
                            [System.Management.Automation.ErrorCategory]::InvalidArgument,
                            $Type

                        )

                    )

                }

                $URI = "$($ISPSSSession.tenant_url)/JobFlow/GetJobs"

            }
        }

        $Body = [ordered]@{
            'type' = $Type
            'Args' = [ordered]@{
                'PageNumber' = $PageNumber
                'PageSize'   = $PageSize
                'Limit'      = $PageSize
                'SortBy'     = 'Description'
                'Ascending'  = $true
                'Direction'  = 'ASC'
                'Caching'    = -1
            }
        }

        $Request = @{

            'URI'    = $URI
            'Method' = 'POST'
            'Body'   = ($Body | ConvertTo-Json -Depth 6)

        }

        #Send Request
        $Result = Invoke-IDRestMethod @Request

        $Result.Results.Row

    }#process

    END {}#end

}
