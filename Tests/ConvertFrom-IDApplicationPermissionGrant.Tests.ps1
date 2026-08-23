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

        Context 'Single rights' {

            It 'decodes Grant (1)' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 1 | Should -Be 'Grant'

            }

            It 'decodes View (4)' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 4 | Should -Be 'View'

            }

            It 'decodes Admin (8)' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 8 | Should -Be 'Admin'

            }

            It 'decodes ViewDetail (16)' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 16 | Should -Be 'ViewDetail'

            }

            It 'decodes Delete (64)' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 64 | Should -Be 'Delete'

            }

            It 'decodes Execute (128)' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 128 | Should -Be 'Execute'

            }

            It 'decodes Automatic (2147483648) - beyond Int32 range' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 2147483648 | Should -Be 'Automatic'

            }

        }

        Context 'Combined rights' {

            It 'decodes all confirmed rights together (2147483869)' {

                $Result = ConvertFrom-IDApplicationPermissionGrant -Grant 2147483869

                $Result | Should -Be @('Grant', 'View', 'Admin', 'ViewDetail', 'Delete', 'Execute', 'Automatic')

            }

            It 'decodes a live-captured inherited Read Only grant (20)' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 20 | Should -Be @('View', 'ViewDetail')

            }

            It 'decodes a live-captured inherited Common Service grant (93)' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 93 | Should -Be @('Grant', 'View', 'Admin', 'ViewDetail', 'Delete')

            }

        }

        Context 'No rights' {

            It 'returns nothing for 0' {

                ConvertFrom-IDApplicationPermissionGrant -Grant 0 | Should -BeNullOrEmpty

            }

        }

    }

}
