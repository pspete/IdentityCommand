# .ExternalHelp IdentityCommand-help.xml
Function Get-IDUser {

    [CmdletBinding(DefaultParameterSetName = 'GetUsers')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GetUser'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GetUserByName'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$username
    )

    BEGIN {
        #ParameterSet name matches URL portion for different requests
        $Request = @{}
        $Request['URI'] = "$Script:tenant_url/CDirectoryService/$($PSCmdlet.ParameterSetName)"
        $Request['Method'] = 'POST'
    }#begin

    PROCESS {

        #Include a body only if parameters specified
        If ($PSBoundParameters.Keys.Count -ge 1) {
            $Request['Body'] = $PSBoundParameters | Get-Parameter | ConvertTo-Json
        }

        #Send Request
        $result = Invoke-IDRestMethod @Request

        #if results, output them
        if ($null -ne $result) {
            switch ($PSCmdlet.ParameterSetName) {
                'GetUsers' {
                    #get users results are part of the returned object
                    $result.Results.Row
                }
                default {
                    #single users are returned directly from request
                    $result
                }
            }
        }

    }#process

    END {}#end

}