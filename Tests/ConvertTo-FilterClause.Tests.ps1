Describe $($PSCommandPath -Replace '.Tests.ps1') {

    BeforeAll {
        #Get Current Directory
        $Here = Split-Path -Parent $PSCommandPath

        #Assume ModuleName from Repository Root folder
        $ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

        #Resolve Path to Module Directory
        $ModulePath = Resolve-Path "$Here\..\$ModuleName"

        #Define Path to Module Manifest
        $ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

        if ( -not (Get-Module -Name $ModuleName -All)) {

            Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

        }

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        Context 'Clause Format' {

            It 'joins field, operator and value with spaces' {
                ConvertTo-FilterClause -Field name -Operator CONTAINS -Value my |
                    Should -Be 'name CONTAINS my'
            }

            It 'accepts field, operator and value positionally' {
                ConvertTo-FilterClause name CONTAINS my |
                    Should -Be 'name CONTAINS my'
            }

            It 'preserves the case of the operator' {
                ConvertTo-FilterClause -Field name -Operator NOTCONTAINS -Value my |
                    Should -Be 'name NOTCONTAINS my'
            }

            It 'omits the value when no value is supplied' {
                ConvertTo-FilterClause -Field requestor -Operator is_null |
                    Should -Be 'requestor is_null'
            }

            It 'returns a string' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value my |
                    Should -BeOfType [string]
            }

        }

        Context 'Quoting' {

            It 'does not quote a value which does not require it' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value somevalue |
                    Should -Be 'name EQ somevalue'
            }

            It 'quotes a value containing a space' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value 'some value' |
                    Should -Be 'name EQ "some value"'
            }

            It 'quotes a value containing <_>' -ForEach @("`t", "`n") {
                ConvertTo-FilterClause -Field name -Operator EQ -Value "some$($_)value" |
                    Should -Be "name EQ `"some$($_)value`""
            }

            It 'quotes an empty value' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value '' |
                    Should -Be 'name EQ ""'
            }

            It 'quotes a null value as an empty value' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value $null |
                    Should -Be 'name EQ ""'
            }

            It 'quotes a value which does not require it when QuoteValue is specified' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value somevalue -QuoteValue |
                    Should -Be 'name EQ "somevalue"'
            }

            It 'escapes a quote character within a quoted value' {
                ConvertTo-FilterClause -Field name -Operator CONTAINS -Value 'my "inner" value' |
                    Should -Be 'name CONTAINS "my \"inner\" value"'
            }

            It 'quotes a value containing a quote character but no whitespace' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value 'my"value' |
                    Should -Be 'name EQ "my\"value"'
            }

            It 'quotes with a single quote when specified' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value 'some value' -QuoteCharacter "'" |
                    Should -Be "name EQ 'some value'"
            }

            It 'escapes the single quote character when quoting with single quotes' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value "it's a value" -QuoteCharacter "'" |
                    Should -Be "name EQ 'it\'s a value'"
            }

            It 'does not escape a double quote when quoting with single quotes' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value 'a "quoted" value' -QuoteCharacter "'" |
                    Should -Be "name EQ 'a `"quoted`" value'"
            }

            It 'does not url encode the clause' {
                ConvertTo-FilterClause -Field name -Operator EQ -Value 'some value' |
                    Should -Not -Match '%'
            }

        }

        Context 'Value Formatting' {

            It 'renders a true boolean in lower case, unquoted' {
                ConvertTo-FilterClause -Field enabled -Operator EQ -Value $true |
                    Should -Be 'enabled EQ true'
            }

            It 'renders a false boolean in lower case, unquoted' {
                ConvertTo-FilterClause -Field enabled -Operator EQ -Value $false |
                    Should -Be 'enabled EQ false'
            }

            It 'renders an integer unquoted' {
                ConvertTo-FilterClause -Field count -Operator gt -Value 5 |
                    Should -Be 'count gt 5'
            }

            It 'renders a decimal in the invariant culture' {
                $Culture = [System.Threading.Thread]::CurrentThread.CurrentCulture

                try {

                    [System.Threading.Thread]::CurrentThread.CurrentCulture = [cultureinfo]::new('de-DE')

                    ConvertTo-FilterClause -Field score -Operator gt -Value 1.5 |
                        Should -Be 'score gt 1.5'

                } finally {

                    [System.Threading.Thread]::CurrentThread.CurrentCulture = $Culture

                }
            }

            It 'renders a date as a round-trip string' {
                $Date = [datetime]::new(2026, 9, 8, 10, 30, 0, [System.DateTimeKind]::Utc)

                ConvertTo-FilterClause -Field created -Operator gt -Value $Date |
                    Should -Be 'created gt 2026-09-08T10:30:00.0000000Z'
            }

            It 'quotes a value type when QuoteValue is specified' {
                ConvertTo-FilterClause -Field count -Operator EQ -Value 5 -QuoteValue |
                    Should -Be 'count EQ "5"'
            }

        }

        Context 'Input Validation' {

            It 'throws when the value is a collection' {
                { ConvertTo-FilterClause -Field name -Operator in -Value @('a', 'b') } |
                    Should -Throw '*formats a single value*'
            }

            It 'throws when the field is empty' {
                { ConvertTo-FilterClause -Field '' -Operator EQ -Value my } | Should -Throw
            }

            It 'throws when the operator is empty' {
                { ConvertTo-FilterClause -Field name -Operator '' -Value my } | Should -Throw
            }

            It 'throws for an unsupported quote character' {
                { ConvertTo-FilterClause -Field name -Operator EQ -Value my -QuoteCharacter '`' } |
                    Should -Throw
            }

        }

        Context 'Dialect Examples' {

            #Clauses as the service documentation renders them - assembly into a complete expression
            #is the responsibility of each consuming module.

            It 'forms the documented Secrets Hub clause <Expected>' -ForEach @(
                @{ Field = 'name'; Operator = 'CONTAINS'; Value = 'my'; Expected = 'name CONTAINS my' }
                @{ Field = 'storeName'; Operator = 'CONTAINS'; Value = 'our'; Expected = 'storeName CONTAINS our' }
                @{ Field = 'name'; Operator = 'EQ'; Value = 'my value'; Expected = 'name EQ "my value"' }
                @{ Field = 'name'; Operator = 'NOTCONTAINS'; Value = 'test'; Expected = 'name NOTCONTAINS test' }
            ) {
                ConvertTo-FilterClause -Field $Field -Operator $Operator -Value $Value |
                    Should -Be $Expected
            }

            It 'forms a clause ready for parenthesised assembly' {
                "($(ConvertTo-FilterClause -Field status -Operator eq -Value pending))" |
                    Should -Be '(status eq pending)'
            }

        }

    }

}
