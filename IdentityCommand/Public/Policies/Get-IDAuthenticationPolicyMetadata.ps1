# TODO: NOT EXPORTED - left out of FunctionsToExport. Policy/GetPolicyMetaData returns a not-found
# error for any input and is absent from the official API docs - likely not a real/current
# endpoint. Left in place for reference only.
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
