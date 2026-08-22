function Get-IDRole {

    [CmdletBinding(DefaultParameterSetName = 'Redrock')]
    param
    (

        [Parameter(Mandatory = $false,
            ParameterSetName = 'Redrock')]
        $Query = @{'Script' = 'Select * from Role ORDER BY Name COLLATE NOCASE' },

        [Parameter(Mandatory = $true,
            ParameterSetName = 'API',
            ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $ID

    )

    begin {

        if ($ID) {

            $API = $true

        }
    } #begin

    process {

        # validates if the API switch is enabled or not
        if (!$API) {

            #Constructed parameters for the rest call
            $RestCall = @{

                'URI'         = "$($ISPSSSession.tenant_url)/redrock/query/"
                'Headers'     = $($ISPSSSession.WebSession.Headers)
                'Method'      = 'Post'
                'Body'        = ($Query | ConvertTo-Json)
                'ContentType' = 'application/json'

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result.Results.Row

        }

        # validates if the API switch is enabled or not
        if ($API -eq $true) {

            #Constructed parameters for the rest call
            $RestCall = @{

                'URI'         = "$($ISPSSSession.tenant_url)/Roles/GetRole?Name=$ID"
                'Headers'     = $($ISPSSSession.WebSession.Headers)
                'Method'      = 'Post'
                'ContentType' = 'application/json'

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }
    } #process

    end {} #end

}

