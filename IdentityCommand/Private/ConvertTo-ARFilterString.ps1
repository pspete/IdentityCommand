function ConvertTo-ARFilterString {
    <#
    .SYNOPSIS
    Assembles an Access Requests filter expression.

    .DESCRIPTION
    Formats filter clauses into the expression syntax accepted by the Access Requests service, which
    requires every expression to be complete within parentheses. Each clause is parenthesised, and
    clauses are combined pairwise from the left, each combination parenthesised in turn:

        1 clause   (a eq 1)
        2 clauses  ((a eq 1) and (b eq 2))
        3 clauses  (((a eq 1) and (b eq 2)) and (c eq 3))

    Values are formatted by ConvertTo-FilterClause and quoted with single quotes, as the service
    documentation renders them. The expression is not url encoded - Add-QueryString encodes the
    query string as a whole.

    .PARAMETER Filter
    The clauses to assemble, each a hashtable with a Field key, an Operator key, and - for operators
    which take one - a Value key. Operators taking no value (is_null, is_not_null, is_true,
    is_false) are given without a Value.

    .PARAMETER LogicalOperator
    The operator to combine clauses with. Defaults to 'and'.

    .EXAMPLE
    ConvertTo-ARFilterString -Filter @{ Field = 'requestState'; Operator = 'eq'; Value = 'finished' }

    Outputs: (requestState eq finished)

    .EXAMPLE
    ConvertTo-ARFilterString -Filter @(
        @{ Field = 'requestState'; Operator = 'eq'; Value = 'finished' }
        @{ Field = 'priority'; Operator = 'gt'; Value = 5 }
        @{ Field = 'createdBy'; Operator = 'eq'; Value = 'John.Doe@cyberark.com' }
    )

    Outputs: (((requestState eq finished) and (priority gt 5)) and (createdBy eq 'John.Doe@cyberark.com'))

    .EXAMPLE
    ConvertTo-ARFilterString -Filter @{ Field = 'finalizationReason'; Operator = 'is_null' }

    Outputs: (finalizationReason is_null)

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
        [hashtable[]]$Filter,

        [parameter(Mandatory = $false)]
        [ValidateSet('and', 'or')]
        [string]$LogicalOperator = 'and'
    )

    begin {

        #Operators which compare against no value
        $ValuelessOperator = @('is_null', 'is_not_null', 'is_true', 'is_false')

        $ValidOperator = $ValuelessOperator + @(
            'eq', 'neq', 'contains', 'not_contains', 'sw', 'ew', 'gt', 'lt', 'ge', 'le', 'in'
        )

        $Clauses = [System.Collections.Generic.List[string]]::new()

        #The service renders anything but a bare word quoted - an email address, a date, a timestamp
        $RequiresQuoting = { param($Item) ($Item -is [string]) -and ($Item -notmatch '^[A-Za-z0-9_]+$') }

    }

    process {

        foreach ($Clause in $Filter) {

            if (-not $Clause.ContainsKey('Field')) {
                throw 'Each filter clause requires a Field'
            }

            if (-not $Clause.ContainsKey('Operator')) {
                throw "Filter clause for field '$($Clause['Field'])' requires an Operator"
            }

            $Operator = $Clause['Operator']

            if ($Operator -notin $ValidOperator) {
                throw "'$Operator' is not a filter operator supported by the Access Requests service. Valid operators are: $($ValidOperator -join ', ')"
            }

            if ($Operator -in $ValuelessOperator) {

                $Clauses.Add($(ConvertTo-FilterClause -Field $Clause['Field'] -Operator $Operator))

            } elseif ($Operator -eq 'in') {

                #TODO: the service documents an 'in' operator but not how it delimits the list.
                #Verify against a tenant before relying on this rendering.
                $Values = @($Clause['Value']) | ForEach-Object {
                    ConvertTo-FilterClause -Value $_ -ValueOnly -QuoteCharacter "'" -QuoteValue:(& $RequiresQuoting $_)
                }

                $Clauses.Add("$($Clause['Field']) in ($($Values -join ', '))")

            } else {

                $Value = $Clause['Value']

                $Clauses.Add($(ConvertTo-FilterClause -Field $Clause['Field'] -Operator $Operator -Value $Value -QuoteCharacter "'" -QuoteValue:(& $RequiresQuoting $Value)))

            }

        }

    }

    end {

        if ($Clauses.Count -eq 0) {

            return

        }

        $Expression = "($($Clauses[0]))"

        for ($i = 1; $i -lt $Clauses.Count; $i++) {

            $Expression = "($Expression $LogicalOperator ($($Clauses[$i])))"

        }

        $Expression

    }

}
