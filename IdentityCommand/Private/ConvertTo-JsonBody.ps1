function ConvertTo-JsonBody {
    <#
    .SYNOPSIS
    Serialises a request body object to a JSON string for the API.

    .DESCRIPTION
    A thin, array-safe wrapper around ConvertTo-Json for building request bodies (the body-side
    counterpart to IdentityCommand's ConvertTo-QueryString).

    Windows PowerShell's ConvertTo-Json unwraps a single-element array when that array is the
    top-level *pipeline* input, so `@($item) | ConvertTo-Json` can emit an object instead of a
    one-element array. This helper always serialises via -InputObject, which is not subject to that
    unwrap, so a body whose property (or whose root) is a single-element collection still serialises
    as a JSON array. It also gives every body a single consistent default depth.

    .PARAMETER Body
    The object to serialise - typically a [hashtable] / [ordered] hashtable of the expected fields.

    .PARAMETER Depth
    ConvertTo-Json depth. Defaults to 8, enough for the module's most deeply nested bodies.

    .PARAMETER Compress
    Emit compact JSON with no whitespace.

    .EXAMPLE
    $body = ConvertTo-JsonBody -Body @{ sessionIds = @($sessionIds) }

    .EXAMPLE
    $body = ConvertTo-JsonBody -Body $Properties -Depth 3
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [object]$Body,

        [parameter(Mandatory = $false)]
        [int]$Depth = 8,

        [parameter(Mandatory = $false)]
        [switch]$Compress
    )

    ConvertTo-Json -InputObject $Body -Depth $Depth -Compress:$Compress

}
