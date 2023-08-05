function Add-CustomType {
    <#
    .SYNOPSIS
    Add a custom type to an object

    .DESCRIPTION
    Adds specified custom type to PowerShell object.

    .PARAMETER Object
    The Object to add the type to

    .PARAMETER Type
    The name of the type to add.

    .EXAMPLE
    $Object | Add-CustomType -type 'Some.Custom.Type'

    Adds 'Some.Custom.Type' to $Object

    #>
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $false
        )]
        [psobject]$Object,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false

        )]
        [string]$Type

    )

    [Void]$Object.PSObject.TypeNames.Insert(0, $Type)

    $Object

}