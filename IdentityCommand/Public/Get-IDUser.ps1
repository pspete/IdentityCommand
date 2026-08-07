# .ExternalHelp IdentityCommand-help.xml
Function Get-IDUser {

    [CmdletBinding(DefaultParameterSetName = 'GetUsers')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GetUser'
        )]
        [parameter(
            Mandatory = $true,
            ParameterSetName = 'GetUserSettings'
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
        [Switch]$CurrentUser,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GetTechSupportUser'
        )]
        [ValidateNotNullOrEmpty()]
        [Switch]$TechSupportUser,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'GetUserSettings'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$SettingType
    )

    BEGIN {
        #ParameterSet name matches URL portion for different requests
        #(overridden below in PROCESS for the GetUserSettings set, which uses a different API)
        $Request = @{}
        $Request['URI'] = "$($ISPSSSession.tenant_url)/CDirectoryService/$($PSCmdlet.ParameterSetName)"
        $Request['Method'] = 'POST'
    }#begin

    PROCESS {

        if ($PSCmdlet.ParameterSetName -eq 'GetUserSettings') {

            #This is a different underlying API (/Core/GetUserSettings) to the other parameter
            #sets (/CDirectoryService/*) - query string based, not a JSON body.
            #UNTESTED: not yet verified against a live tenant.
            $Request['URI'] = "$($ISPSSSession.tenant_url)/Core/GetUserSettings?ID=$($ID | Get-EscapedString)&SettingType=$($SettingType | Get-EscapedString)"

        } else {

            #Include a body only if ID or username parameters specified
            switch ($PSBoundParameters.Keys) {
                ({ $PSItem -match 'ID|username' }) {
                    $Request['Body'] = $PSBoundParameters | Get-Parameter | ConvertTo-Json
                    break
                }
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
