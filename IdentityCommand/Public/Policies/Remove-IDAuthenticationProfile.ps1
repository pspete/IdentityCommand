function Remove-IDAuthenticationProfile {

    [CmdletBinding()]
	param
	(
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name
    )

    BEGIN {} #begin

    PROCESS {

        $Body = @{

            'uuid' = $Name

        }

        #Constructed parameters for the rest call
        $RestCall = @{

            "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/AuthProfile/DeleteProfile"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = ($Body | ConvertTo-Json)
            "ContentType" = "application/json"
            
        }
    
        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    
    } #process

    END {} #end
}
