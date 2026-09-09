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

        Context 'Parenthesisation' {

            It 'parenthesises a single clause' {
                ConvertTo-ARFilterString -Filter @{ Field = 'a'; Operator = 'eq'; Value = '1' } |
                    Should -Be '(a eq 1)'
            }

            It 'parenthesises each clause and the pair' {
                ConvertTo-ARFilterString -Filter @(
                    @{ Field = 'a'; Operator = 'eq'; Value = '1' }
                    @{ Field = 'b'; Operator = 'eq'; Value = '2' }
                ) | Should -Be '((a eq 1) and (b eq 2))'
            }

            It 'combines three clauses pairwise from the left' {
                ConvertTo-ARFilterString -Filter @(
                    @{ Field = 'a'; Operator = 'eq'; Value = '1' }
                    @{ Field = 'b'; Operator = 'eq'; Value = '2' }
                    @{ Field = 'c'; Operator = 'eq'; Value = '3' }
                ) | Should -Be '(((a eq 1) and (b eq 2)) and (c eq 3))'
            }

            It 'combines four clauses pairwise from the left' {
                ConvertTo-ARFilterString -Filter @(
                    @{ Field = 'a'; Operator = 'eq'; Value = '1' }
                    @{ Field = 'b'; Operator = 'eq'; Value = '2' }
                    @{ Field = 'c'; Operator = 'eq'; Value = '3' }
                    @{ Field = 'd'; Operator = 'eq'; Value = '4' }
                ) | Should -Be '((((a eq 1) and (b eq 2)) and (c eq 3)) and (d eq 4))'
            }

            It 'balances its parentheses' {
                $Expression = ConvertTo-ARFilterString -Filter @(
                    @{ Field = 'a'; Operator = 'eq'; Value = '1' }
                    @{ Field = 'b'; Operator = 'eq'; Value = '2' }
                    @{ Field = 'c'; Operator = 'eq'; Value = '3' }
                )

                ($Expression.ToCharArray() | Where-Object { $_ -eq '(' }).Count |
                    Should -Be ($Expression.ToCharArray() | Where-Object { $_ -eq ')' }).Count
            }

            It 'joins with or when specified' {
                ConvertTo-ARFilterString -LogicalOperator or -Filter @(
                    @{ Field = 'a'; Operator = 'eq'; Value = '1' }
                    @{ Field = 'b'; Operator = 'eq'; Value = '2' }
                ) | Should -Be '((a eq 1) or (b eq 2))'
            }

            It 'accepts clauses from the pipeline' {
                @{ Field = 'a'; Operator = 'eq'; Value = '1' } | ConvertTo-ARFilterString |
                    Should -Be '(a eq 1)'
            }

        }

        Context 'Documented Examples' {

            #The filter values from the service's own API documentation

            It 'forms documented example 1' {
                ConvertTo-ARFilterString -Filter @(
                    @{ Field = 'requestState'; Operator = 'eq'; Value = 'finished' }
                    @{ Field = 'priority'; Operator = 'gt'; Value = 5 }
                    @{ Field = 'createdBy'; Operator = 'eq'; Value = 'John.Doe@cyberark.com' }
                ) | Should -Be "(((requestState eq finished) and (priority gt 5)) and (createdBy eq 'John.Doe@cyberark.com'))"
            }

            It 'forms documented example 2' {
                ConvertTo-ARFilterString -Filter @(
                    @{ Field = 'targetCategory'; Operator = 'eq'; Value = 'Cloud console' }
                    @{ Field = 'updatedBy'; Operator = 'eq'; Value = 'Jane.Doe@cyberark.com' }
                ) | Should -Be "((targetCategory eq 'Cloud console') and (updatedBy eq 'Jane.Doe@cyberark.com'))"
            }

            It 'forms documented example 3' {
                ConvertTo-ARFilterString -Filter @(
                    @{ Field = 'calculatedRequestStartTime'; Operator = 'gt'; Value = '2024-01-01 10:00:00' }
                    @{ Field = 'requestResult'; Operator = 'eq'; Value = 'approved' }
                ) | Should -Be "((calculatedRequestStartTime gt '2024-01-01 10:00:00') and (requestResult eq approved))"
            }

            It 'forms documented example 4' {
                ConvertTo-ARFilterString -Filter @(
                    @{ Field = 'createdAt'; Operator = 'ge'; Value = '2022-01-01' }
                    @{ Field = 'finalizationReason'; Operator = 'eq'; Value = 'Not needed anymore' }
                ) | Should -Be "((createdAt ge '2022-01-01') and (finalizationReason eq 'Not needed anymore'))"
            }

        }

        Context 'Value Quoting' {

            It 'leaves a bare word unquoted' {
                ConvertTo-ARFilterString -Filter @{ Field = 'requestState'; Operator = 'eq'; Value = 'finished' } |
                    Should -Be '(requestState eq finished)'
            }

            It 'leaves a number unquoted' {
                ConvertTo-ARFilterString -Filter @{ Field = 'priority'; Operator = 'gt'; Value = 5 } |
                    Should -Be '(priority gt 5)'
            }

            It 'quotes a value containing <_>' -ForEach @('.', '@', '-', ':', ' ', '/') {
                ConvertTo-ARFilterString -Filter @{ Field = 'a'; Operator = 'eq'; Value = "x$($_)y" } |
                    Should -Be "(a eq 'x$($_)y')"
            }

            It 'escapes a single quote within a value' {
                ConvertTo-ARFilterString -Filter @{ Field = 'reason'; Operator = 'eq'; Value = "it's needed" } |
                    Should -Be "(reason eq 'it\'s needed')"
            }

            It 'does not url encode the expression' {
                ConvertTo-ARFilterString -Filter @{ Field = 'createdBy'; Operator = 'eq'; Value = 'a@b.com' } |
                    Should -Not -Match '%'
            }

        }

        Context 'Operators' {

            It 'accepts the documented operator <_>' -ForEach @(
                'eq', 'neq', 'contains', 'not_contains', 'sw', 'ew', 'gt', 'lt', 'ge', 'le'
            ) {
                ConvertTo-ARFilterString -Filter @{ Field = 'a'; Operator = $_; Value = '1' } |
                    Should -Be "(a $_ 1)"
            }

            It 'omits the value for the valueless operator <_>' -ForEach @(
                'is_null', 'is_not_null', 'is_true', 'is_false'
            ) {
                ConvertTo-ARFilterString -Filter @{ Field = 'a'; Operator = $_ } |
                    Should -Be "(a $_)"
            }

            It 'ignores a value supplied to a valueless operator' {
                ConvertTo-ARFilterString -Filter @{ Field = 'a'; Operator = 'is_null'; Value = 'ignored' } |
                    Should -Be '(a is_null)'
            }

            It 'renders a list for the in operator' {
                ConvertTo-ARFilterString -Filter @{ Field = 'priority'; Operator = 'in'; Value = @('High', 'Low') } |
                    Should -Be '(priority in (High, Low))'
            }

            It 'quotes list values which require quoting' {
                ConvertTo-ARFilterString -Filter @{ Field = 'createdBy'; Operator = 'in'; Value = @('a@b.com', 'c@d.com') } |
                    Should -Be "(createdBy in ('a@b.com', 'c@d.com'))"
            }

            It 'renders a single value for the in operator' {
                ConvertTo-ARFilterString -Filter @{ Field = 'priority'; Operator = 'in'; Value = 'High' } |
                    Should -Be '(priority in (High))'
            }

            It 'throws for an operator the service does not support' {
                { ConvertTo-ARFilterString -Filter @{ Field = 'a'; Operator = 'LIKE'; Value = '1' } } |
                    Should -Throw '*not a filter operator supported by the Access Requests service*'
            }

            It 'throws for an unsupported logical operator' {
                { ConvertTo-ARFilterString -LogicalOperator xor -Filter @{ Field = 'a'; Operator = 'eq'; Value = '1' } } |
                    Should -Throw
            }

        }

        Context 'Input Validation' {

            It 'throws when a clause has no Field' {
                { ConvertTo-ARFilterString -Filter @{ Operator = 'eq'; Value = '1' } } |
                    Should -Throw '*requires a Field*'
            }

            It 'throws when a clause has no Operator' {
                { ConvertTo-ARFilterString -Filter @{ Field = 'a'; Value = '1' } } |
                    Should -Throw '*requires an Operator*'
            }

        }

    }

}
