# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Get-IDSCIMUser {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN {
        $Request = @{
            'Resource' = 'Users'
            'Method'   = 'GET'
        }
    }#begin

    PROCESS {

        if ($PSBoundParameters.ContainsKey('ID')) {

            $Request['ID'] = $ID

        }

        #Send Request
        Invoke-IDSCIMRequest @Request

    }#process

    END {}#end

}
