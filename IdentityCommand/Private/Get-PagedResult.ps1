function Get-PagedResult {
    <#
    .SYNOPSIS
    Follows API pagination and returns the combined result set.

    .DESCRIPTION
    List endpoints page in one of two ways:
      - Cursor: the response carries an opaque continuation token (nextCursor,
        b64_last_evaluated_key, etc) which is resent verbatim as a query parameter
        until it comes back null/empty.
      - Offset: the response (or a separate count endpoint) carries a total record
        count, and successive pages are requested by incrementing an offset query
        parameter until that many results have been collected.

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

    .PARAMETER TotalCount
    Offset style only. Use when the total record count is not present on the response
    itself and was instead obtained from a separate request (eg strong accounts'
    /api/secrets/count). Overrides TotalResponseKey.

    .EXAMPLE
    Get-PagedResult -InitialResult $result -URI $URI -Style Cursor -ResultProperty items -CursorResponseKey nextCursor -CursorRequestKey cursor

    .EXAMPLE
    Get-PagedResult -InitialResult $result -URI $URI -Style Offset -ResultProperty items -TotalResponseKey totalCount -OffsetRequestKey offset

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
        [int]$TotalCount
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
                    $NextCursor = $PageResult.$CursorResponseKey

                }

            }

            'Offset' {

                $Total = if ($PSBoundParameters.ContainsKey('TotalCount')) { $TotalCount } else { $InitialResult.$TotalResponseKey }

                #Tracks the previous page's first item so a server that silently ignores the offset
                #parameter (observed on more than one endpoint) is detected and stopped, rather than
                #having the same page appended over and over until Total is reached.
                $PreviousPageFirstItem = if (@($InitialItems).Count -gt 0) { @($InitialItems)[0] | ConvertTo-Json -Compress -Depth 5 } else { $null }

                while (($null -ne $Total) -and ($Items.Count -lt $Total)) {

                    $PageURI = Add-QueryString -URI $URI -Parameter @{ $OffsetRequestKey = $Items.Count }

                    $PageResult = Invoke-IDRestMethod -Uri $PageURI -Method GET
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
