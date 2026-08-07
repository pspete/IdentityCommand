# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: This wraps two distinct underlying endpoints that both appear to "set user state" but with
# different value shapes - /cdirectoryservice/setuserstate (free-form -State string, sample value
# 'None' - the full set of valid values is undocumented) and /CDirectoryService/ChangeUserState
# (boolean -Enabled). It's unclear whether these two endpoints are redundant or serve genuinely
# different purposes (e.g. granular lock/suspend state vs. simple enable/disable). The lowercase
# path for setuserstate is exactly as recorded in the source sample (unusual - the rest of this API
# is PascalCase) and is kept faithfully as-is; untested whether PascalCase also works.
function Set-IDUserState {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByState')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ByState'
        )]
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ByEnabled'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(
            Mandatory = $true,
            ParameterSetName = 'ByState'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$State,

        [parameter(
            Mandatory = $true,
            ParameterSetName = 'ByEnabled'
        )]
        [Bool]$Enabled
    )

    BEGIN {}#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {
            'ByState' {

                if ($PSCmdlet.ShouldProcess($ID, "Set User State to '$State'")) {

                    $Request = @{

                        'URI'    = "$($ISPSSSession.tenant_url)/cdirectoryservice/setuserstate"
                        'Method' = 'POST'
                        'Body'   = (@{ 'ID' = $ID; 'state' = $State } | ConvertTo-Json)

                    }

                    Invoke-IDRestMethod @Request

                }

            }
            'ByEnabled' {

                if ($PSCmdlet.ShouldProcess($ID, "Set User Enabled State to '$Enabled'")) {

                    $Request = @{

                        'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/ChangeUserState"
                        'Method' = 'POST'
                        'Body'   = (@{ 'uuid' = $ID; 'state' = $Enabled } | ConvertTo-Json)

                    }

                    Invoke-IDRestMethod @Request

                }

            }
        }

    }#process

    END {}#end

}
