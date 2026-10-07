function ConvertTo-FilterClause {
    <#
    .SYNOPSIS
    Formats a single field/operator/value filter clause.

    .DESCRIPTION
    Several ISPSS services accept a filter expression as a query parameter, each in its own dialect.
    The dialects differ in operator vocabulary, in how clauses are joined, and in whether expressions
    are parenthesised, so clause assembly belongs to the calling module. What they share is how an
    individual clause is formed and how its value is quoted; this helper owns that.

    The returned clause is NOT url encoded. The filter is a value within a query string, and the
    query string is encoded as a whole further down - by Add-QueryString / ConvertTo-QueryString -
    so encoding here would double encode it.

    Values are quoted only when the value requires it: a string containing whitespace or a quote
    character, or an empty string. Quote characters within a quoted value are escaped with a
    backslash. Strings which need no quoting are emitted bare, as the dialects render them.

    Booleans are rendered lowercase and numbers in the invariant culture, so neither picks up
    PowerShell or locale specific formatting. Dates are rendered as ISO 8601 (round-trip) strings.
    A null value is rendered as an empty string.

    A single value is formatted. List operators are rendered by the calling module, which knows how
    its dialect delimits a list; an enumerable value is an error rather than a joined string.

    .PARAMETER Field
    The name of the field to filter on.

    .PARAMETER Operator
    The comparison operator. Each dialect supports its own set - validation of the operator belongs
    to the calling module, which knows which are valid for its service.

    .PARAMETER Value
    The value to compare against. Omit for operators which take no value, such as is_null.

    .PARAMETER QuoteValue
    Specify to quote the value whether or not it requires quoting.

    .PARAMETER QuoteCharacter
    The character to quote values with. Defaults to a double quote.

    .PARAMETER ValueOnly
    Specify to return the formatted value alone, without a field or operator. Dialects which render
    a list of values - for an 'in' operator, say - format each of their values this way and delimit
    them themselves.

    .EXAMPLE
    ConvertTo-FilterClause -Field name -Operator CONTAINS -Value my

    Outputs: name CONTAINS my

    .EXAMPLE
    ConvertTo-FilterClause -Field name -Operator EQ -Value 'some value'

    Outputs: name EQ "some value"

    .EXAMPLE
    ConvertTo-FilterClause -Field name -Operator EQ -Value 'my "inner" value'

    Outputs: name EQ "my \"inner\" value"

    .EXAMPLE
    ConvertTo-FilterClause -Field requestor -Operator is_null

    Outputs: requestor is_null

    .EXAMPLE
    ConvertTo-FilterClause -Value 'some value' -ValueOnly

    Outputs: "some value"

    .OUTPUTS
    String
    #>
    [CmdletBinding(DefaultParameterSetName = 'Clause')]
    [OutputType([string])]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Clause'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Field,

        [parameter(
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'Clause'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Operator,

        [parameter(
            Mandatory = $false,
            Position = 2,
            ParameterSetName = 'Clause'
        )]
        [parameter(
            Mandatory = $true,
            ParameterSetName = 'Value'
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [object]$Value,

        [parameter(
            Mandatory = $true,
            ParameterSetName = 'Value'
        )]
        [switch]$ValueOnly,

        [parameter(Mandatory = $false)]
        [switch]$QuoteValue,

        [parameter(Mandatory = $false)]
        [ValidateSet('"', "'")]
        [string]$QuoteCharacter = '"'
    )

    if (-not $PSBoundParameters.ContainsKey('Value')) {

        return "$Field $Operator"

    }

    if (($Value -isnot [string]) -and ($Value -is [System.Collections.IEnumerable])) {

        throw 'ConvertTo-FilterClause formats a single value. Compose clauses for list operators in the calling module, which knows how its dialect renders a list'

    }

    if ($Value -is [bool]) {

        $FormattedValue = $Value.ToString().ToLowerInvariant()
        $RequiresQuoting = $false

    } elseif ($Value -is [datetime]) {

        $FormattedValue = $Value.ToString('o', [cultureinfo]::InvariantCulture)
        $RequiresQuoting = $false

    } elseif ($Value -is [valuetype]) {

        $FormattedValue = [string]::Format([cultureinfo]::InvariantCulture, '{0}', $Value)
        $RequiresQuoting = $false

    } else {

        $FormattedValue = [string]$Value
        $RequiresQuoting = ($FormattedValue -match '\s') -or
            ($FormattedValue.Contains($QuoteCharacter)) -or
            ([string]::IsNullOrEmpty($FormattedValue))

    }

    if ($QuoteValue -or $RequiresQuoting) {

        #A quote character within a quoted value is escaped with a backslash
        $FormattedValue = $FormattedValue.Replace($QuoteCharacter, "\$QuoteCharacter")
        $FormattedValue = "$QuoteCharacter$FormattedValue$QuoteCharacter"

    }

    if ($ValueOnly) {

        return $FormattedValue

    }

    "$Field $Operator $FormattedValue"

}
