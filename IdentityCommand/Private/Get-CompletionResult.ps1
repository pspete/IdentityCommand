function Get-CompletionResult {
    <#
    .SYNOPSIS
    Turns objects returned by a Get-* command into CompletionResult entries.

    .DESCRIPTION
    Shared formatting/filtering for the module's argument completers. Given the objects a
    Get-* lookup returned, the word the user is completing, and the candidate property
    name(s) that hold the value to place on the command line (plus optional label
    property name(s) for the tooltip), it emits one [CompletionResult] per match.

    Matching is a prefix match, case-insensitive, against either the value or the label so a
    policy can be found by its id or its name. Values containing whitespace are single
    quoted so they bind as a single argument.

    .PARAMETER InputObject
    The objects returned by the Get-* command. Accepts pipeline input.

    .PARAMETER WordToComplete
    The partial value the completion engine passed in.

    .PARAMETER ValueProperty
    Property name(s) holding the value to complete, tried in order; the first non-empty wins.

    .PARAMETER LabelProperty
    Optional property name(s) holding a friendly label for the tooltip, tried in order.

    .EXAMPLE
    $items | Get-CompletionResult -WordToComplete $wordToComplete -ValueProperty policyId -LabelProperty name
    #>
    [OutputType([System.Management.Automation.CompletionResult])]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [object[]]$InputObject,

        [parameter(Mandatory = $false)]
        [string]$WordToComplete,

        [parameter(Mandatory = $true)]
        [string[]]$ValueProperty,

        [parameter(Mandatory = $false)]
        [string[]]$LabelProperty
    )

    begin {
        #Drop any opening quote the user has already typed.
        $Word = "$WordToComplete".Trim("'`"")
    }#begin

    process {

        foreach ($Item in $InputObject) {

            $Value = $ValueProperty | ForEach-Object { $Item.$_ } | Where-Object { $_ } | Select-Object -First 1
            if (-not $Value) { continue }

            $Label = $LabelProperty | ForEach-Object { $Item.$_ } | Where-Object { $_ } | Select-Object -First 1

            #Force scalar strings - an empty $Label from an absent property would otherwise make the
            #-notlike below evaluate to an empty array and break the -and.
            $Value = "$Value"
            $Label = "$Label"

            if (($Value -notlike "$Word*") -and ($Label -notlike "$Word*")) { continue }

            $CompletionText = if ($Value -match '\s') { "'$($Value -replace "'", "''")'" } else { "$Value" }
            $ToolTip = if ($Label -and ($Label -ne $Value)) { "$Label ($Value)" } else { "$Value" }

            [System.Management.Automation.CompletionResult]::new($CompletionText, $ToolTip, 'ParameterValue', $ToolTip)

        }

    }#process

    end { }#end

}
