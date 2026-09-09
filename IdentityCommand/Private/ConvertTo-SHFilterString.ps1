function ConvertTo-SHFilterString {
    <#
    .SYNOPSIS
    Assembles a Secrets Hub filter expression.

    .DESCRIPTION
    Formats filter clauses into the query language accepted by the Secrets Hub service. The dialect
    is deliberately simple: clauses are juxtaposed and joined with AND, there is no OR, and
    parentheses are not supported.

        name CONTAINS my AND storeName CONTAINS our

    Comparison is by EQ, CONTAINS or NOTCONTAINS, and values are case insensitive. A value
    containing whitespace is quoted, and a quote character within a quoted value is escaped with a
    backslash - both handled by ConvertTo-FilterClause. Callers pass raw values and never pre-quote.

    The expression is not url encoded - Add-QueryString encodes the query string as a whole.

    .PARAMETER Filter
    The clauses to assemble, each a hashtable with Field, Operator and Value keys.

    .EXAMPLE
    ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'CONTAINS'; Value = 'my' }

    Outputs: name CONTAINS my

    .EXAMPLE
    ConvertTo-SHFilterString -Filter @(
        @{ Field = 'name'; Operator = 'CONTAINS'; Value = 'my' }
        @{ Field = 'storeName'; Operator = 'CONTAINS'; Value = 'our' }
    )

    Outputs: name CONTAINS my AND storeName CONTAINS our

    .EXAMPLE
    ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'EQ'; Value = 'my value' }

    Outputs: name EQ "my value"

    .OUTPUTS
    String
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [hashtable[]]$Filter
    )

    begin {

        #The documented query language supports these three comparison operators. The secret stores
        #endpoint's spec additionally shows HAS and GE, which are unverified and excluded until
        #confirmed against a tenant.
        $ValidOperator = @('EQ', 'CONTAINS', 'NOTCONTAINS')

        $Clauses = [System.Collections.Generic.List[string]]::new()

    }

    process {

        foreach ($Clause in $Filter) {

            if (-not $Clause.ContainsKey('Field')) {
                throw 'Each filter clause requires a Field'
            }

            if (-not $Clause.ContainsKey('Operator')) {
                throw "Filter clause for field '$($Clause['Field'])' requires an Operator"
            }

            if (-not $Clause.ContainsKey('Value')) {
                throw "Filter clause for field '$($Clause['Field'])' requires a Value"
            }

            $Operator = $Clause['Operator']

            if ($Operator -notin $ValidOperator) {
                throw "'$Operator' is not a filter operator supported by the Secrets Hub service. Valid operators are: $($ValidOperator -join ', ')"
            }

            $Clauses.Add($(ConvertTo-FilterClause -Field $Clause['Field'] -Operator $Operator -Value $Clause['Value']))

        }

    }

    end {

        if ($Clauses.Count -eq 0) {

            return

        }

        $Clauses -join ' AND '

    }

}
