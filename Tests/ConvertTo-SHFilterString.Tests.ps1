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

        Context 'Assembly' {

            It 'forms a single clause' {
                ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'CONTAINS'; Value = 'my' } |
                    Should -Be 'name CONTAINS my'
            }

            It 'joins clauses with AND' {
                ConvertTo-SHFilterString -Filter @(
                    @{ Field = 'name'; Operator = 'CONTAINS'; Value = 'my' }
                    @{ Field = 'storeName'; Operator = 'CONTAINS'; Value = 'our' }
                ) | Should -Be 'name CONTAINS my AND storeName CONTAINS our'
            }

            It 'joins three clauses with AND' {
                ConvertTo-SHFilterString -Filter @(
                    @{ Field = 'a'; Operator = 'EQ'; Value = '1' }
                    @{ Field = 'b'; Operator = 'EQ'; Value = '2' }
                    @{ Field = 'c'; Operator = 'EQ'; Value = '3' }
                ) | Should -Be 'a EQ 1 AND b EQ 2 AND c EQ 3'
            }

            It 'does not parenthesise the expression' {
                ConvertTo-SHFilterString -Filter @(
                    @{ Field = 'a'; Operator = 'EQ'; Value = '1' }
                    @{ Field = 'b'; Operator = 'EQ'; Value = '2' }
                ) | Should -Not -Match '[()]'
            }

            It 'accepts clauses from the pipeline' {
                @{ Field = 'name'; Operator = 'CONTAINS'; Value = 'my' } | ConvertTo-SHFilterString |
                    Should -Be 'name CONTAINS my'
            }

        }

        Context 'Value Quoting' {

            It 'leaves a value which needs no quoting unquoted' {
                ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'CONTAINS'; Value = 'my' } |
                    Should -Be 'name CONTAINS my'
            }

            It 'quotes a value containing a space' {
                ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'EQ'; Value = 'my value' } |
                    Should -Be 'name EQ "my value"'
            }

            It 'escapes a quote within a quoted value' {
                ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'CONTAINS'; Value = 'my "inner" value' } |
                    Should -Be 'name CONTAINS "my \"inner\" value"'
            }

            It 'does not url encode the expression' {
                ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'EQ'; Value = 'my value' } |
                    Should -Not -Match '%'
            }

        }

        Context 'Operators' {

            It 'accepts the documented operator <_>' -ForEach @('EQ', 'CONTAINS', 'NOTCONTAINS') {
                ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = $_; Value = 'my' } |
                    Should -Be "name $_ my"
            }

            It 'throws for an operator outside the documented query language' {
                { ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'CONTAINS_ANY'; Value = 'my' } } |
                    Should -Throw '*not a filter operator supported by the Secrets Hub service*'
            }

            It 'throws for the unverified <_> operator' -ForEach @('HAS', 'GE') {
                { ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = $_; Value = 'my' } } |
                    Should -Throw '*not a filter operator supported by the Secrets Hub service*'
            }

        }

        Context 'Input Validation' {

            It 'throws when a clause has no Field' {
                { ConvertTo-SHFilterString -Filter @{ Operator = 'EQ'; Value = 'my' } } |
                    Should -Throw '*requires a Field*'
            }

            It 'throws when a clause has no Operator' {
                { ConvertTo-SHFilterString -Filter @{ Field = 'name'; Value = 'my' } } |
                    Should -Throw '*requires an Operator*'
            }

            It 'throws when a clause has no Value' {
                { ConvertTo-SHFilterString -Filter @{ Field = 'name'; Operator = 'EQ' } } |
                    Should -Throw '*requires a Value*'
            }

        }

    }

}
