# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - live-tested 2026-08-21 against JobFlow/GetJobs. The server rejects both no
# body and an explicit -Type with a .NET ArgumentException on the "type" parameter, meaning -Type is
# actually mandatory server-side and must be one of a specific (currently unknown) enum, not the
# free-text optional filter this command's signature assumes. Two guessed values both failed
# identically ("Specified value is invalid, Parameter name: type"): omitting it, and
# 'ExportDynamicRoleMembers' (a real async report-job type name seen elsewhere in this module). The
# "JobFlow" naming (StartJob/DeleteJob/Event) more plausibly describes an access-request/approval
# workflow engine than a generic report-job list, which would mean -Type enumerates request/workflow
# types (e.g. Role, Application) rather than report names - unconfirmed. Not being pursued further by
# guessing; the reliable next step is capturing a real request via browser DevTools while an actual
# access request/approval is in flight in the CyberArk Identity portal.
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
