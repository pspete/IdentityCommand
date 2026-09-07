function ConvertTo-DateString {
    <#
    .SYNOPSIS
    Formats a date for the API.

    .DESCRIPTION
    Dates are sent as UTC ISO 8601 strings (for example 2022-07-12T00:00:00.000Z).
    Commands accept a standard [datetime] from the caller and convert it here so the format is defined
    in a single place.

    .PARAMETER Date
    The date to format. Converted to UTC before formatting.

    .EXAMPLE
    ConvertTo-DateString -Date (Get-Date '2022-07-12')

    Returns 2022-07-12T00:00:00.000Z when the local time zone is UTC.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [datetime]$Date
    )

    process {

        $Date.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fffZ', [System.Globalization.CultureInfo]::InvariantCulture)

    }#process

}
