function Get-PagedResult {
    <#
    .SYNOPSIS
    Follows API pagination and returns the combined result set.

    .DESCRIPTION
    List endpoints page in one of two ways:
      - Cursor: the response carries an opaque continuation token (nextCursor,
        b64_last_evaluated_key, etc) which is resent verbatim as a query parameter
        until it comes back null/empty.
      - Offset: successive pages are requested by moving an offset on until the whole
        set has been collected. Endpoints signal the end of the set in one of three
        ways - a total record count on the response (or from a separate count
        endpoint), an explicit last page flag (isLastPage), or a next offset echoed
        back and omitted on the final page. The offset travels as a query parameter
        by default, or in the request body for endpoints which page a POST.

    Adapted from psPAS's Get-NextLink, which auto-detects nextLink/nextCursor/totalCount
    shapes against a single API convention. The ISPSS service APIs have no single
    convention across their endpoints - cursor/offset/total field and query parameter
    names differ, and some endpoints report their total from a wholly separate endpoint -
    so callers here state which fields and keys apply rather than relying on
    auto-detection.

    .PARAMETER InitialResult
    The already-fetched first page of results.

    .PARAMETER URI
    The URI used for the initial request (without any paging query parameter appended).
    Subsequent pages are requested against this URI.

    .PARAMETER Style
    'Cursor' to follow a continuation token, 'Offset' to page via an incrementing offset
    query parameter against a known/reported total.

    .PARAMETER ResultProperty
    The property on the response holding the array of items. Omit when the response
    itself is a bare array.

    .PARAMETER CursorRequestKey
    Cursor style only. Query parameter name the continuation token is sent back as.

    .PARAMETER CursorResponseKey
    Cursor style only. Property on the response holding the next continuation token.

    .PARAMETER OffsetRequestKey
    Offset style only. Query parameter name used to request the next page.

    .PARAMETER TotalResponseKey
    Offset style only. Property on the response holding the total record count.
    Ignored if TotalCount is supplied.

    .PARAMETER OffsetResponseKey
    Offset style only. Property on the response holding the offset the next page starts at,
    absent or empty on the final page. Accepts a dotted path for a nested value, for example
    'paging.offset'. When supplied, the next page is requested at the offset the server reports
    rather than at the number of items collected so far.

    .PARAMETER LastPageKey
    Offset style only. Boolean property on the response which is true on the final page, for
    example 'isLastPage'. Takes precedence over OffsetResponseKey and any reported total.

    .PARAMETER Method
    Offset style only. The method used to request subsequent pages. Defaults to GET, where the
    offset is sent as a query parameter. Specify POST for endpoints which take their paging values
    in the request body, and supply BodyTemplate.

    .PARAMETER BodyTemplate
    Offset style only, required with Method POST. The body sent with the initial request. It is
    cloned per page with the offset replaced, so filters and search terms carry across pages.

    .PARAMETER BodyPagingProperty
    Offset style only. Name of a nested object in the body which holds the paging values, for
    example 'paging'. Omit when the offset sits at the top level of the body.

    .PARAMETER TotalCount
    Offset style only. Use when the total record count is not present on the response
    itself and was instead obtained from a separate request (eg strong accounts'
    /api/secrets/count). Overrides TotalResponseKey.

    .EXAMPLE
    Get-PagedResult -InitialResult $result -URI $URI -Style Cursor -ResultProperty items -CursorResponseKey nextCursor -CursorRequestKey cursor

    .EXAMPLE
    Get-PagedResult -InitialResult $result -URI $URI -Style Offset -ResultProperty items -TotalResponseKey totalCount -OffsetRequestKey offset

    .EXAMPLE
    Get-PagedResult -InitialResult $result -URI $URI -Style Offset -ResultProperty findings -LastPageKey isLastPage

    .EXAMPLE
    Get-PagedResult -InitialResult $result -URI $URI -Style Offset -ResultProperty standingAccess -Method POST -BodyTemplate $Body -BodyPagingProperty paging -OffsetResponseKey paging.offset

    .INPUTS
    None. InitialResult is not accepted from the pipeline - a bare-array API response 
    would otherwise be split into one pipeline call per element instead of a single call with the whole array.

    .OUTPUTS
    All items across all pages.
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        $InitialResult,

        [parameter(Mandatory = $true)]
        [string]$URI,

        [parameter(Mandatory = $true)]
        [ValidateSet('Cursor', 'Offset')]
        [string]$Style,

        [parameter(Mandatory = $false)]
        [string]$ResultProperty,

        [parameter(Mandatory = $false)]
        [string]$CursorRequestKey = 'cursor',

        [parameter(Mandatory = $false)]
        [string]$CursorResponseKey = 'nextCursor',

        [parameter(Mandatory = $false)]
        [string]$OffsetRequestKey = 'offset',

        [parameter(Mandatory = $false)]
        [string]$TotalResponseKey = 'totalCount',

        [parameter(Mandatory = $false)]
        [int]$TotalCount,

        [parameter(Mandatory = $false)]
        [string]$OffsetResponseKey,

        [parameter(Mandatory = $false)]
        [string]$LastPageKey,

        [parameter(Mandatory = $false)]
        [ValidateSet('GET', 'POST')]
        [string]$Method = 'GET',

        [parameter(Mandatory = $false)]
        $BodyTemplate,

        [parameter(Mandatory = $false)]
        [string]$BodyPagingProperty
    )

    process {

        #Local helper to pull the item array out of a page, whether it's wrapped in a property or a bare array
        $GetItems = {
            param($PageResult)
            if ($ResultProperty) { $PageResult.$ResultProperty } else { $PageResult }
        }

        $Items = [Collections.Generic.List[Object]]::New()

        $InitialItems = & $GetItems $InitialResult
        if ($null -ne $InitialItems) {
            $null = $Items.AddRange(@($InitialItems))
        }

        switch ($Style) {

            'Cursor' {

                $NextCursor = $InitialResult.$CursorResponseKey

                while (-not [String]::IsNullOrEmpty($NextCursor)) {

                    $PageURI = Add-QueryString -URI $URI -Parameter @{ $CursorRequestKey = $NextCursor }

                    $PageResult = Invoke-IDRestMethod -Uri $PageURI -Method GET
                    $PageItems = & $GetItems $PageResult

                    if (($null -eq $PageItems) -or (@($PageItems).Count -eq 0)) {
                        break
                    }

                    $null = $Items.AddRange(@($PageItems))

                    $ThisCursor = $NextCursor
                    $NextCursor = $PageResult.$CursorResponseKey

                    if ($NextCursor -eq $ThisCursor) {
                        #The server handed back the cursor just sent, so following it would request
                        #this same page for ever. Endpoints which report a cursor unconditionally
                        #(SIA's VM infrastructure reports cloud_0|onprem_0 once exhausted) make this
                        #reachable, as does an endpoint which ignores the cursor parameter entirely.
                        break
                    }

                }

            }

            'Offset' {

                if ($Method -eq 'POST' -and $null -eq $BodyTemplate) {
                    throw 'BodyTemplate is required when paging with Method POST'
                }

                $Total = if ($PSBoundParameters.ContainsKey('TotalCount')) { $TotalCount } else { $InitialResult.$TotalResponseKey }

                #Resolves a dotted property path, so a next-offset reported as a nested value
                #(CDS reports paging.offset) can be read the same way as a top level one.
                $GetPathValue = {
                    param($Object, $Path)
                    $Value = $Object
                    foreach ($Segment in ($Path -split '\.')) {
                        if ($null -eq $Value) { break }
                        $Value = $Value.$Segment
                    }
                    $Value
                }

                #Three ways an endpoint says whether another page exists, in precedence order:
                #an explicit last page flag, a next offset echoed back (absent on the final page),
                #or the collected count reaching a reported total.
                $HasMorePages = {
                    param($PageResult)
                    if ($LastPageKey) {
                        -not [bool]($PageResult.$LastPageKey)
                    } elseif ($OffsetResponseKey) {
                        -not [string]::IsNullOrEmpty((& $GetPathValue $PageResult $OffsetResponseKey))
                    } else {
                        ($null -ne $Total) -and ($Items.Count -lt $Total)
                    }
                }

                #Tracks the previous page's first item so a server that silently ignores the offset
                #parameter (observed on more than one endpoint) is detected and stopped, rather than
                #having the same page appended over and over until Total is reached.
                $PreviousPageFirstItem = if (@($InitialItems).Count -gt 0) { @($InitialItems)[0] | ConvertTo-Json -Compress -Depth 5 } else { $null }

                $LastPage = $InitialResult

                while (& $HasMorePages $LastPage) {

                    #An echoed next offset is the server's own idea of where the next page starts;
                    #otherwise pick up from however many items have been collected so far.
                    $NextOffset = if ($OffsetResponseKey) {
                        & $GetPathValue $LastPage $OffsetResponseKey
                    } else {
                        $Items.Count
                    }

                    $PageResult = if ($Method -eq 'POST') {

                        $PageBody = Get-SessionClone -InputObject $BodyTemplate

                        if ($BodyPagingProperty) {
                            if ($null -eq $PageBody[$BodyPagingProperty]) { $PageBody[$BodyPagingProperty] = [ordered]@{} }
                            $PageBody[$BodyPagingProperty][$OffsetRequestKey] = $NextOffset
                        } else {
                            $PageBody[$OffsetRequestKey] = $NextOffset
                        }

                        Invoke-IDRestMethod -Uri $URI -Method POST -Body ($PageBody | ConvertTo-Json -Depth 8)

                    } else {

                        $PageURI = Add-QueryString -URI $URI -Parameter @{ $OffsetRequestKey = $NextOffset }
                        Invoke-IDRestMethod -Uri $PageURI -Method GET

                    }

                    $LastPage = $PageResult
                    $PageItems = & $GetItems $PageResult

                    if (($null -eq $PageItems) -or (@($PageItems).Count -eq 0)) {
                        #Defends against a reported total the server never actually delivers
                                                break
                    }

                    $CurrentPageFirstItem = @($PageItems)[0] | ConvertTo-Json -Compress -Depth 5

                    if ($CurrentPageFirstItem -eq $PreviousPageFirstItem) {
                        #Offset didn't move the server on - stop rather than duplicate this page's items
                        break
                    }

                    $null = $Items.AddRange(@($PageItems))
                    $PreviousPageFirstItem = $CurrentPageFirstItem

                }

            }

        }

        $Items

    }#process

}
