function Get-ArgumentCompleter {
    <#
    .SYNOPSIS
    Builds an argument-completer scriptblock backed by a Get-* command.

    .DESCRIPTION
    Returns a scriptblock suitable for Register-ArgumentCompleter. When invoked by the completion
    engine it dispatches the lookup into the owning module, skips the call when there is no active
    session, and swallows any error so tab completion stays silent rather than noisy.

    .PARAMETER RetrievalCommand
    Name of the Get-* command to call for candidate objects.

    .PARAMETER ValueProperty
    Property name(s) on the returned objects holding the value to complete, tried in order.

    .PARAMETER LabelProperty
    Optional property name(s) holding a friendly label for the tooltip, tried in order.

    .EXAMPLE
    Register-ArgumentCompleter -ParameterName policy_id -CommandName Remove-SCAPolicy -ScriptBlock (
        Get-ArgumentCompleter -RetrievalCommand Get-SCAPolicy -ValueProperty policyId -LabelProperty name
    )

    Registered by a companion module for one of its own commands.
    #>
    [OutputType([scriptblock])]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Captured by GetNewClosure and used inside the returned scriptblock')]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$RetrievalCommand,

        [parameter(Mandatory = $true)]
        [string[]]$ValueProperty,

        [parameter(Mandatory = $false)]
        [string[]]$LabelProperty
    )

    {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

        #Standard ArgumentCompleter parameters that are not otherwise referenced.
        $null = $parameterName, $commandAst, $fakeBoundParameters

        try {
            $Module = (Get-Command $commandName -ErrorAction Stop).Module

            & $Module {
                param($Retrieval, $ValueProperty, $LabelProperty, $Word)

                #No point calling the API before the module's Connect- command has run.
                if ([string]::IsNullOrWhiteSpace($ISPSSSession.tenant_url)) { return }

                & $Retrieval -ErrorAction Stop |
                    Get-CompletionResult -WordToComplete $Word -ValueProperty $ValueProperty -LabelProperty $LabelProperty
            } $RetrievalCommand $ValueProperty $LabelProperty $wordToComplete

        } catch { return }

    }.GetNewClosure()

}
