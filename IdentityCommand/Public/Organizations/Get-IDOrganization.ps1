# .ExternalHelp IdentityCommand-help.xml
function Get-IDOrganization {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'ID'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$OrgId,

        [parameter(
            Mandatory = $false,
            ParameterSetName = 'All'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Format
    )

    BEGIN {}#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {
            'ID' {

                $Request = @{

                    'URI'    = "$($ISPSSSession.tenant_url)/Org/Get"
                    'Method' = 'POST'
                    'Body'   = (@{ 'OrgId' = $OrgId } | ConvertTo-Json)

                }

            }
            'All' {

                $URI = "$($ISPSSSession.tenant_url)/Org/ListAll"

                if ($PSBoundParameters.ContainsKey('Format')) {

                    $URI = "$URI`?format=$($Format | Get-EscapedString)"

                }

                $Request = @{

                    'URI'    = $URI
                    'Method' = 'POST'

                }

            }
        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}
