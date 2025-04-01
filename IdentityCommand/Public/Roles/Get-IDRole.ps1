function Get-IDRole {

    [CmdletBinding(DefaultParameterSetName = 'Redrock')]
	param
	(
       
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'Redrock')]
		$Query = @{"Script" = "Select * from Role ORDER BY Name COLLATE NOCASE"},

        [Parameter(Mandatory = $true, 
        ParameterSetName = 'API')]
		[Alias('Uuid')]
        $Name,

        [Parameter(Mandatory = $true, 
        ParameterSetName = 'AllRolesAndRights')]
        $Path

    )

    BEGIN {

        if ($Name) {

            $API = $true

        }

        if ($Path) {

            $AllRolesAndRights = $true

        }

    } #begin

    PROCESS {
        
        # validates if the API switch is enabled or not
        if (!$API -and !$AllRolesAndRights) {

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
        if ($API -eq $true) {

            #Constructed parameters for the rest call
            $RestCall = @{

                "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/GetRole?Name=$Name"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        } 

        if ($AllRolesAndRights -eq $true) {

            Write-Host -ForegroundColor Green "Trying AllRoles call"
            $RestCall = @{

                "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Core/GetDirectoryRolesAndRights?path=$Path"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "ContentType" = "application/json"

            }

            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    } #process

    END {} #end

}

