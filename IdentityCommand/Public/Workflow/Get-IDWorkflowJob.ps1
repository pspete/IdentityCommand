# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Get-IDWorkflowJob {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $false,
            ParameterSetName = 'Mine'
        )]
        [Switch]$Mine,

        [parameter(Mandatory = $false)]
        [String]$Type
    )

    BEGIN {}#begin

    PROCESS {

        $Body = @{}

        if ($PSBoundParameters.ContainsKey('Type')) {

            $Body['type'] = $Type

        }

        switch ($PSCmdlet.ParameterSetName) {
            'Mine' {

                $URI = "$($ISPSSSession.tenant_url)/JobFlow/GetMyJobs"

            }
            'All' {

                $URI = "$($ISPSSSession.tenant_url)/JobFlow/GetJobs"

            }
        }

        $Request = @{

            'URI'    = $URI
            'Method' = 'POST'
            'Body'   = ($Body | ConvertTo-Json -Depth 6)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}
