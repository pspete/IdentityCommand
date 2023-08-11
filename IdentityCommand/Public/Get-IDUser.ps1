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
        [String]$ID,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GetUserByName'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$username,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GetUserAttributes'
        )]
        [ValidateNotNullOrEmpty()]
        [Switch]$CurrentUser
    )

    BEGIN {
        #ParameterSet name matches URL portion for different requests
        $Request = @{}
        $Request['URI'] = "$Script:tenant_url/CDirectoryService/$($PSCmdlet.ParameterSetName)"
        $Request['Method'] = 'POST'
    }#begin

    PROCESS {

        #Include a body only if ID or username parameters specified
        switch ($PSBoundParameters.Keys) {
            ({ $PSItem -match 'ID|username' }) {
                $Request['Body'] = $PSBoundParameters | Get-Parameter | ConvertTo-Json
                break
            }
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