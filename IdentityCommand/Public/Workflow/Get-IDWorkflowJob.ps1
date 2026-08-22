# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - JobFlow/GetJobs rejects both no body and an explicit -Type with a .NET
# ArgumentException, meaning -Type is actually mandatory server-side and must be one of a specific
# (currently unknown) enum, not the free-text optional filter this command's signature assumes.
# Needs a DevTools capture of a real request while an access request/approval is in flight.
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

        }

        if ($Body.Count -gt 0) {

            $Request['Body'] = ($Body | ConvertTo-Json -Depth 6)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}
