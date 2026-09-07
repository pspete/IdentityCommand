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

        BeforeAll {
            $Script:PageURI = 'https://sometenant.service.cyberark.cloud/api/things'
        }

        Context 'Cursor style' {

            It 'returns the initial items when there is no continuation token' {
                Mock -CommandName Invoke-IDRestMethod -MockWith { }

                $Initial = [pscustomobject]@{ items = @('one', 'two'); nextCursor = $null }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Cursor -ResultProperty items |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 0 -Exactly -Scope It
            }

            It 'follows the continuation token until it is empty' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); nextCursor = $null }
                }

                $Initial = [pscustomobject]@{ items = @('one'); nextCursor = 'SomeCursor' }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Cursor -ResultProperty items |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

            It 'sends the continuation token as a query parameter' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); nextCursor = $null }
                }

                $Initial = [pscustomobject]@{ items = @('one'); nextCursor = 'SomeCursor' }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Cursor -ResultProperty items

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    $URI -eq 'https://sometenant.service.cyberark.cloud/api/things?cursor=SomeCursor'
                } -Times 1 -Exactly -Scope It
            }

            It 'joins the continuation token to an existing query string' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); nextCursor = $null }
                }

                $Initial = [pscustomobject]@{ items = @('one'); nextCursor = 'SomeCursor' }
                $null = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?limit=10" -Style Cursor -ResultProperty items

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    $URI -eq 'https://sometenant.service.cyberark.cloud/api/things?limit=10&cursor=SomeCursor'
                } -Times 1 -Exactly -Scope It
            }

            It 'honours non-default cursor keys' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ target_sets = @('two'); b64_last_evaluated_key = $null }
                }

                $Initial = [pscustomobject]@{ target_sets = @('one'); b64_last_evaluated_key = 'SomeKey' }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Cursor -ResultProperty target_sets -CursorRequestKey 'b64StartKey' -CursorResponseKey 'b64_last_evaluated_key' |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    $URI -eq 'https://sometenant.service.cyberark.cloud/api/things?b64StartKey=SomeKey'
                } -Times 1 -Exactly -Scope It
            }

            It 'stops when a page returns no items' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @(); nextCursor = 'StillSomeCursor' }
                }

                $Initial = [pscustomobject]@{ items = @('one'); nextCursor = 'SomeCursor' }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Cursor -ResultProperty items |
                    Should -Be @('one')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

            It 'walks more than one page' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); nextCursor = 'Cursor2' }
                } -ParameterFilter { $URI -match 'cursor=Cursor1' }

                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('three'); nextCursor = $null }
                } -ParameterFilter { $URI -match 'cursor=Cursor2' }

                $Initial = [pscustomobject]@{ items = @('one'); nextCursor = 'Cursor1' }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Cursor -ResultProperty items |
                    Should -Be @('one', 'two', 'three')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 2 -Exactly -Scope It
            }

        }

        Context 'Offset style' {

            It 'pages until the reported total is collected' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); totalCount = 2 }
                }

                $Initial = [pscustomobject]@{ items = @('one'); totalCount = 2 }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

            It 'sends the number of items already collected as the offset' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); totalCount = 2 }
                }

                $Initial = [pscustomobject]@{ items = @('one'); totalCount = 2 }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    $URI -eq 'https://sometenant.service.cyberark.cloud/api/things?offset=1'
                } -Times 1 -Exactly -Scope It
            }

            It 'makes no further request when the first page holds the total' {
                Mock -CommandName Invoke-IDRestMethod -MockWith { }

                $Initial = [pscustomobject]@{ items = @('one', 'two'); totalCount = 2 }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 0 -Exactly -Scope It
            }

            It 'uses a total supplied by the caller in place of one on the response' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two') }
                }

                #Mirrors an endpoint which reports its total from a separate count request
                $Initial = [pscustomobject]@{ items = @('one') }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -TotalCount 2 |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

            It 'makes no request when no total is reported' {
                Mock -CommandName Invoke-IDRestMethod -MockWith { }

                $Initial = [pscustomobject]@{ items = @('one') }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items |
                    Should -Be @('one')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 0 -Exactly -Scope It
            }

            It 'stops when a page returns no items despite an unmet total' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @(); totalCount = 100 }
                }

                $Initial = [pscustomobject]@{ items = @('one'); totalCount = 100 }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items |
                    Should -Be @('one')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

            It 'stops when the server ignores the offset and repeats a page' {
                #Without the repeated-page guard the same item would be appended until totalCount was reached
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('one'); totalCount = 100 }
                }

                $Initial = [pscustomobject]@{ items = @('one'); totalCount = 100 }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items |
                    Should -Be @('one')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

            It 'honours a non-default offset request key' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); total = 2 }
                }

                $Initial = [pscustomobject]@{ items = @('one'); total = 2 }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -OffsetRequestKey 'skip' -TotalResponseKey 'total'

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    $URI -eq 'https://sometenant.service.cyberark.cloud/api/things?skip=1'
                } -Times 1 -Exactly -Scope It
            }

        }

        Context 'Bare array responses' {

            It 'treats the response itself as the item collection when no ResultProperty is given' {
                Mock -CommandName Invoke-IDRestMethod -MockWith { , @('two') }

                Get-PagedResult -InitialResult @('one') -URI $Script:PageURI -Style Offset -TotalCount 2 |
                    Should -Be @('one', 'two')
            }

            It 'does not split a bare-array InitialResult into one call per element' {
                Mock -CommandName Invoke-IDRestMethod -MockWith { }

                #InitialResult is deliberately not pipeline-bound: passing an array must yield a single
                #call holding every element, not one call per element.
                Get-PagedResult -InitialResult @('one', 'two', 'three') -URI $Script:PageURI -Style Cursor |
                    Should -HaveCount 3
            }

        }

    }

}
