# .ExternalHelp IdentityCommand-help.xml
function Get-IDSCIMSchema {
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
            'Resource' = 'Schemas'
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
