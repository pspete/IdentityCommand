function Get-IDRole {

    [CmdletBinding(DefaultParameterSetName = 'Redrock')]
	param
	(
       
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'Redrock')]
		$Query = @{"Script" = "Select * from Role ORDER BY Name COLLATE NOCASE"},

        [Parameter(Mandatory = $true, ParameterSetName = 'API')]
		$UUID,

        [Parameter(Mandatory = $false, ParameterSetName = 'API')]
        [switch]$API
	)

    BEGIN {} #begin

    PROCESS {
        
        # validates if the API switch is enabled or not
        if (!$API) {

            #Constructed parameters for the rest call
            $RestCall = @{

                "URI"         = "https://$($ISPSSSession.tenantID).id.cyberark.cloud/redrock/query/"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "Body"        = ($Query | ConvertTo-Json)
                "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result.Results.Row

        }

        # validates if the API switch is enabled or not
        if ($API) {

            #Constructed parameters for the rest call
            $RestCall = @{

                "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/GetRole?Name=$UUID"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "ContentType" = "application/json"

            }
            
            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result.Result

        } 

    } #process

    END {} #end

}

