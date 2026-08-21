# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
function Get-IDSCIMGroup {
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
            'Resource' = 'Groups'
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
