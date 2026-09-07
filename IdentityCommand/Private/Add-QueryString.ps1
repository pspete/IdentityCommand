function Add-QueryString {
    <#
    .SYNOPSIS
    Appends a query string to a request URI.

    .DESCRIPTION
    Single place the module forms a URL query string. Null/empty values are dropped, the remaining
    key/value pairs are formatted by IdentityCommand's ConvertTo-QueryString helper, and the result is
    joined to the URI with the correct separator.

    Many endpoints also accept a 'debug' query parameter which enriches the API's error payload.
    PowerShell reserves -Debug as a common parameter, so the module has no parameter of its own for this;
    instead, commands calling an endpoint which documents 'debug' pass -SupportsDebug, and this helper
    sends debug=true whenever the caller ran the command with -Debug (or otherwise has $DebugPreference
    set to something other than SilentlyContinue).

    .PARAMETER URI
    The request URI to append the query string to. Returned unaltered when there is nothing to append.

    .PARAMETER Parameter
    Hashtable of query parameter names and values, typically projected from $PSBoundParameters via
    Get-Parameter.

    .PARAMETER SupportsDebug
    Specify when the target endpoint documents the 'debug' query parameter.

    .EXAMPLE
    $URI = Add-QueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter) -SupportsDebug

    .EXAMPLE
    $URI = Add-QueryString -URI $URI -Parameter @{ limit = 100 }
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]$URI,

        [parameter(
            Mandatory = $false,
            Position = 1
        )]
        [hashtable]$Parameter,

        [parameter(Mandatory = $false)]
        [switch]$SupportsDebug
    )

    $QueryParameter = @{ }

    if ($null -ne $Parameter) {

        foreach ($key in $Parameter.Keys) {

            if (-not [string]::IsNullOrEmpty("$($Parameter[$key])")) {

                $QueryParameter[$key] = $Parameter[$key]

            }

        }

    }

    if ($SupportsDebug -and ($DebugPreference -ne 'SilentlyContinue')) {

        $QueryParameter['debug'] = 'true'

    }

    $QueryString = $QueryParameter | ConvertTo-QueryString

    if ([string]::IsNullOrEmpty($QueryString)) {

        return $URI

    }

    $Separator = if ($URI -match '\?') { '&' } else { '?' }

    "$URI$Separator$QueryString"

}
