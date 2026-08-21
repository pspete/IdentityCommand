# Confirmed live 2026-08-21: despite the parameter name, the 'API' set's -Name (Roles/GetRole)
# requires the role's actual ID/UUID/_RowKey, not its display name - it only ever worked for
# well-known roles like 'sysadmin' by coincidence (their RowKey happens to equal their display
# name). Added -ID as an explicit alias for discoverability (it was already aliased -Uuid).
function Get-IDRole {

    [CmdletBinding(DefaultParameterSetName = 'Redrock')]
	param
	(
       
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'Redrock')]
		$Query = @{"Script" = "Select * from Role ORDER BY Name COLLATE NOCASE"},

        [Parameter(Mandatory = $true,
        ParameterSetName = 'API',
        ValueFromPipelinebyPropertyName = $true)]
		[Alias('Uuid', 'ID')]
        $Name

    )

    BEGIN {

        if ($Name) {

            $API = $true

        }
    } #begin

    PROCESS {
        
        # validates if the API switch is enabled or not
        if (!$API) {

            #Constructed parameters for the rest call
            $RestCall = @{

                "URI"         = "$($ISPSSSession.tenant_url)/redrock/query/"
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
        if ($API -eq $true) {

            #Constructed parameters for the rest call
            $RestCall = @{

                "URI"         = "$($ISPSSSession.tenant_url)/Roles/GetRole?Name=$Name"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }
    } #process

    END {} #end

}

