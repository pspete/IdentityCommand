function Select-RequestProperty {
    <#
    .SYNOPSIS
    Projects supplied parameters into an ordered set of API properties.

    .DESCRIPTION
    Where a request body or query string must contain only the fields the caller actually supplied -
    sending an unset field as null would either be rejected or would clear a value - this helper walks
    the expected property names in order and keeps only those present in the supplied parameters.

    The counterpart, Merge-Parameter, is used instead where every expected property must be present
    in the request (falling back to an existing object or a default).

    .PARAMETER Property
    The expected property names, in the order they should appear in the request.

    .PARAMETER BoundParameter
    The projected bound parameters (typically $PSBoundParameters | Get-Parameter).

    .EXAMPLE
    $Properties = Select-RequestProperty -Property $ExpectedProperties -BoundParameter ($PSBoundParameters | Get-Parameter)
    #>
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string[]]$Property,

        [parameter(
            Mandatory = $true,
            Position = 1
        )]
        [AllowNull()]
        [hashtable]$BoundParameter
    )

    $Selected = [ordered]@{ }

    foreach ($Name in $Property) {

        if (($null -ne $BoundParameter) -and ($BoundParameter.ContainsKey($Name))) {

            $Selected[$Name] = $BoundParameter[$Name]

        }

    }

    $Selected

}
