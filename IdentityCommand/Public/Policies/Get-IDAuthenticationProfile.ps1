# .ExternalHelp IdentityCommand-help.xml
function Get-IDAuthenticationProfile {

    [CmdletBinding()]
	param
	(
        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name
    )

    BEGIN {} #begin

    PROCESS {

        if (!$Name) {

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/AuthProfile/GetDecoratedProfileList"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result.Results.row
        }

        if ($Name) {

            $Body = @{

                'uuid' = $Name

            }

            #Constructed parameters for the rest call
            $RestCall = @{

                "URI"         = "$($ISPSSSession.tenant_url)/AuthProfile/GetProfile"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "Body"        = ($Body | ConvertTo-Json)
                "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }
    } #process

    END {} #end
}
