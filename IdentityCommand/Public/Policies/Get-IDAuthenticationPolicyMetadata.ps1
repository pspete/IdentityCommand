# NOT EXPORTED - left out of FunctionsToExport in the manifest. Confirmed against a live tenant
# that Policy/GetPolicyMetaData always returns "The requested data or its dependent data was not
# found in the service", both with no body and with -Name set to a real, working policy name (in
# both bare and full "/Policy/<name>" forms - the exact shapes GetPolicyBlock accepts). The
# endpoint is also absent from the official CyberArk API docs (Policy Management section lists
# GetPolicyBlock, GetNicePlinks, GetPasswordComplexityRequirements, SavePolicyBlock3,
# DeletePolicyBlock - no GetPolicyMetaData), matching the same pattern as the also-unexported
# Get-IDPagedRoleMember. Likely not a real/current endpoint - left in place for reference only.
function Get-IDAuthenticationPolicyMetadata {

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Metadata is already singular')]
    [CmdletBinding()]
	param
	(
        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('PolicySet', 'ID')]
        $Name

    )

    BEGIN {} #begin

    PROCESS {

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/Policy/GetPolicyMetaData"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "ContentType" = "application/json"

            }

            if ($PSBoundParameters.ContainsKey('Name')) {

                $RestCall['Body'] = (@{ 'Name' = $Name } | ConvertTo-Json)

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result.Results.Row
        } #process

    END {} #end
}
