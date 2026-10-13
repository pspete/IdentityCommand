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

            It 'stops when the server returns the same continuation token it was sent' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); nextCursor = 'SomeCursor' }
                }

                $Initial = [pscustomobject]@{ items = @('one'); nextCursor = 'SomeCursor' }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Cursor -ResultProperty items |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
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

        Context 'Offset style - last page flag' {

            It 'pages until the response reports the last page' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); isLastPage = $true }
                }

                $Initial = [pscustomobject]@{ items = @('one'); isLastPage = $false }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -LastPageKey isLastPage |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

            It 'makes no further request when the first page is the last' {
                Mock -CommandName Invoke-IDRestMethod -MockWith { }

                $Initial = [pscustomobject]@{ items = @('one'); isLastPage = $true }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -LastPageKey isLastPage |
                    Should -Be @('one')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 0 -Exactly -Scope It
            }

            It 'pages on a last page flag without any reported total' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); isLastPage = $true }
                }

                $Initial = [pscustomobject]@{ items = @('one'); isLastPage = $false }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -LastPageKey isLastPage

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    $URI -match 'offset=1'
                } -Times 1 -Exactly -Scope It
            }

        }

        Context 'Offset style - next offset echoed by the server' {

            It 'requests the next page at the offset the server reports' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); paging = [pscustomobject]@{} }
                }

                $Initial = [pscustomobject]@{ items = @('one'); paging = [pscustomobject]@{ offset = 500 } }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -OffsetResponseKey 'paging.offset'

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    $URI -match 'offset=500'
                } -Times 1 -Exactly -Scope It
            }

            It 'stops when the response omits the next offset' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); paging = [pscustomobject]@{} }
                }

                $Initial = [pscustomobject]@{ items = @('one'); paging = [pscustomobject]@{ offset = 1 } }
                Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -OffsetResponseKey 'paging.offset' |
                    Should -Be @('one', 'two')

                Should -Invoke -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

        }

        Context 'Offset style - paging a POST' {

            It 'sends the offset in the request body' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); totalCount = 2 }
                }

                $Initial = [pscustomobject]@{ items = @('one'); totalCount = 2 }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -Method POST -BodyTemplate @{ limit = 1 }

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    ($Method -eq 'POST') -and
                    ($URI -eq $Script:PageURI) -and
                    (($Body | ConvertFrom-Json).offset -eq 1) -and
                    (($Body | ConvertFrom-Json).limit -eq 1)
                } -Times 1 -Exactly -Scope It
            }

            It 'carries the rest of the body across pages' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); totalCount = 2 }
                }

                $Initial = [pscustomobject]@{ items = @('one'); totalCount = 2 }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -Method POST -BodyTemplate @{ filters = @{ cloudProviders = @('AZURE') } }

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    ($Body | ConvertFrom-Json).filters.cloudProviders -contains 'AZURE'
                } -Times 1 -Exactly -Scope It
            }

            It 'sets the offset inside a nested paging property when one is named' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); paging = [pscustomobject]@{} }
                }

                $Initial = [pscustomobject]@{ items = @('one'); paging = [pscustomobject]@{ offset = 100 } }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -Method POST -BodyTemplate ([ordered]@{ paging = [ordered]@{ limit = 100 } }) -BodyPagingProperty paging -OffsetResponseKey 'paging.offset'

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    ($Parsed.paging.offset -eq 100) -and ($Parsed.paging.limit -eq 100)
                } -Times 1 -Exactly -Scope It
            }

            It 'throws when POST is requested without a body template' {
                Mock -CommandName Invoke-IDRestMethod -MockWith { }

                $Initial = [pscustomobject]@{ items = @('one'); totalCount = 2 }
                { Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -Method POST } |
                    Should -Throw '*BodyTemplate is required*'
            }

            It 'does not send a body when paging a GET' {
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ items = @('two'); totalCount = 2 }
                }

                $Initial = [pscustomobject]@{ items = @('one'); totalCount = 2 }
                $null = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items

                Should -Invoke -CommandName Invoke-IDRestMethod -ParameterFilter {
                    ($Method -eq 'GET') -and ($null -eq $Body)
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

        Context 'Starting position supplied by the caller' {

            BeforeAll {
                #Values of a query key, in order, as the raw (still encoded) strings sent
                $Script:GetQueryValue = {
                    param($Target, $Key)
                    $Query = ([uri]$Target).Query.TrimStart('?')
                    @($Query -split '&' | Where-Object { $_ -like "$Key=*" } | ForEach-Object { $_.Substring($Key.Length + 1) })
                }

                #A page of the fake data set, starting at Offset, as a server would return it
                $Script:GetPage = {
                    param($Offset)
                    $Last = [Math]::Min($Offset + $Script:PageLimit, $Script:SetSize) - 1
                    $Slice = if ($Offset -le $Last) { @($Offset..$Last) } else { @() }
                    [pscustomobject]@{
                        items      = $Slice
                        totalCount = $Script:SetSize
                        isLastPage = ($Offset + $Script:PageLimit -ge $Script:SetSize)
                    }
                }
            }

            BeforeEach {
                $Script:PageLimit = 10
                $Script:SetSize = 25
                $Script:Requests = [Collections.Generic.List[string]]::New()
                $Script:Bodies = [Collections.Generic.List[object]]::New()

                #Like the live servers, uses the last offset value when a key is repeated
                Mock -CommandName Invoke-IDRestMethod -MockWith {
                    $null = $Script:Requests.Add($URI)
                    if ($Body) {
                        $Parsed = $Body | ConvertFrom-Json
                        $null = $Script:Bodies.Add($Parsed)
                        $Offset = if ($Parsed.paging) { $Parsed.paging.offset } else { $Parsed.offset }
                    } else {
                        $Offset = @(& $Script:GetQueryValue $URI 'offset') | Select-Object -Last 1
                    }
                    & $Script:GetPage ([int]$Offset)
                }
            }

            Context 'Offset style, GET' {

                It 'pages from zero when the URI holds no offset' {
                    $Initial = & $Script:GetPage 0
                    $Result = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?limit=10" -Style Offset -ResultProperty items

                    $Result | Should -Be @(0..24)
                    $Script:Requests | Should -Be @(
                        "$($Script:PageURI)?limit=10&offset=10"
                        "$($Script:PageURI)?limit=10&offset=20"
                    )
                }

                It 'advances from the offset in the URI' {
                    $Initial = & $Script:GetPage 5
                    $Result = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?limit=10&offset=5" -Style Offset -ResultProperty items

                    $Result | Should -Be @(5..24)
                    $Script:Requests | Should -Be @(
                        "$($Script:PageURI)?limit=10&offset=15"
                    )
                }

                It 'sends exactly one offset on each later request' {
                    $Script:SetSize = 45
                    $Initial = & $Script:GetPage 5
                    $null = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?offset=5&limit=10" -Style Offset -ResultProperty items

                    $Script:Requests | Should -HaveCount 3
                    foreach ($Request in $Script:Requests) {
                        @(& $Script:GetQueryValue $Request 'offset') | Should -HaveCount 1
                    }
                    $Script:Requests | ForEach-Object { & $Script:GetQueryValue $_ 'offset' } | Should -Be @('15', '25', '35')
                }

                It 'drops a URI holding only the offset back to the bare path' {
                    $Initial = & $Script:GetPage 5
                    $null = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?offset=5" -Style Offset -ResultProperty items

                    $Script:Requests | Should -Be @("$($Script:PageURI)?offset=15")
                }

                It 'keeps the other query keys byte for byte' {
                    $Initial = & $Script:GetPage 5
                    $null = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?severity=CRITICAL%2CHIGH&limit=10&offset=5&name=a%20b%2Bc" -Style Offset -ResultProperty items

                    $Script:Requests | Should -Be @(
                        "$($Script:PageURI)?severity=CRITICAL%2CHIGH&limit=10&name=a%20b%2Bc&offset=15"
                    )
                }

                It 'collects the expected items with a last page flag and a starting offset' {
                    #Mirrors Get-RMFinding -offset 5 -limit 10 against 115 findings
                    $Script:SetSize = 115
                    $Initial = & $Script:GetPage 5
                    $Result = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?offset=5&limit=10" -Style Offset -ResultProperty items -LastPageKey isLastPage

                    $Result | Should -Be @(5..114)
                    $Script:Requests | Should -HaveCount 10
                    $Script:Requests | ForEach-Object { & $Script:GetQueryValue $_ 'offset' } | Should -Be @('15', '25', '35', '45', '55', '65', '75', '85', '95', '105')
                }

                It 'honours a non-default offset request key already in the URI' {
                    Mock -CommandName Invoke-IDRestMethod -MockWith {
                        $null = $Script:Requests.Add($URI)
                        & $Script:GetPage ([int](@(& $Script:GetQueryValue $URI 'skip') | Select-Object -Last 1))
                    }

                    $Initial = & $Script:GetPage 5
                    $Result = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?skip=5&top=10" -Style Offset -ResultProperty items -OffsetRequestKey skip

                    $Result | Should -Be @(5..24)
                    $Script:Requests | Should -Be @("$($Script:PageURI)?top=10&skip=15")
                }

                It 'leaves the server reported next offset authoritative' {
                    Mock -CommandName Invoke-IDRestMethod -MockWith {
                        $null = $Script:Requests.Add($URI)
                        [pscustomobject]@{ items = @('two'); paging = [pscustomobject]@{} }
                    }

                    $Initial = [pscustomobject]@{ items = @('one'); paging = [pscustomobject]@{ offset = 500 } }
                    $null = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?offset=5&limit=10" -Style Offset -ResultProperty items -OffsetResponseKey 'paging.offset'

                    $Script:Requests | Should -Be @("$($Script:PageURI)?limit=10&offset=500")
                }

                It 'still stops when the server ignores the offset' {
                    Mock -CommandName Invoke-IDRestMethod -MockWith {
                        $null = $Script:Requests.Add($URI)
                        & $Script:GetPage 5
                    }

                    $Initial = & $Script:GetPage 5
                    $Result = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?offset=5&limit=10" -Style Offset -ResultProperty items

                    $Result | Should -Be @(5..14)
                    $Script:Requests | Should -HaveCount 1
                }

            }

            Context 'Offset style, POST' {

                It 'pages from zero when the body holds no offset' {
                    $Initial = & $Script:GetPage 0
                    $Result = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -Method POST -BodyTemplate @{ limit = 10 }

                    $Result | Should -Be @(0..24)
                    $Script:Bodies | ForEach-Object { $_.offset } | Should -Be @(10, 20)
                    $Script:Requests | Should -Be @($Script:PageURI, $Script:PageURI)
                }

                It 'advances from a top level offset in the body' {
                    $Script:SetSize = 35
                    $Initial = & $Script:GetPage 5
                    $Result = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -Method POST -BodyTemplate @{ limit = 10; offset = 5; filter = 'x' }

                    $Result | Should -Be @(5..34)
                    $Script:Bodies | ForEach-Object { $_.offset } | Should -Be @(15, 25)
                    $Script:Bodies | ForEach-Object { $_.filter } | Should -Be @('x', 'x')
                }

                It 'advances from an offset in the nested paging property' {
                    $Script:SetSize = 35
                    $Initial = & $Script:GetPage 5
                    $Template = [ordered]@{ paging = [ordered]@{ limit = 10; offset = 5 } }
                    $Result = Get-PagedResult -InitialResult $Initial -URI $Script:PageURI -Style Offset -ResultProperty items -Method POST -BodyTemplate $Template -BodyPagingProperty paging

                    $Result | Should -Be @(5..34)
                    $Script:Bodies | ForEach-Object { $_.paging.offset } | Should -Be @(15, 25)
                    $Template.paging.offset | Should -Be 5
                }

            }

            Context 'Cursor style' {

                BeforeEach {
                    #Cursor N returns item N and points at N+1, up to item 3
                    Mock -CommandName Invoke-IDRestMethod -MockWith {
                        $null = $Script:Requests.Add($URI)
                        $Cursor = [int](@(& $Script:GetQueryValue $URI 'cursor') | Select-Object -Last 1)
                        [pscustomobject]@{ items = @($Cursor); nextCursor = $(if ($Cursor -lt 3) { $Cursor + 1 }) }
                    }
                }

                It 'sends the next cursor when the URI holds none' {
                    $Initial = [pscustomobject]@{ items = @(0); nextCursor = 1 }
                    $Result = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?limit=1" -Style Cursor -ResultProperty items

                    $Result | Should -Be @(0, 1, 2, 3)
                    $Script:Requests | Should -Be @(
                        "$($Script:PageURI)?limit=1&cursor=1"
                        "$($Script:PageURI)?limit=1&cursor=2"
                        "$($Script:PageURI)?limit=1&cursor=3"
                    )
                }

                It 'replaces a starting cursor in the URI, keeping the other keys byte for byte' {
                    $Initial = [pscustomobject]@{ items = @(1); nextCursor = 2 }
                    $Result = Get-PagedResult -InitialResult $Initial -URI "$($Script:PageURI)?cursor=1&q=a%2Cb%20c&limit=1" -Style Cursor -ResultProperty items

                    $Result | Should -Be @(1, 2, 3)
                    $Script:Requests | Should -Be @(
                        "$($Script:PageURI)?q=a%2Cb%20c&limit=1&cursor=2"
                        "$($Script:PageURI)?q=a%2Cb%20c&limit=1&cursor=3"
                    )
                }

            }

        }

    }

}
