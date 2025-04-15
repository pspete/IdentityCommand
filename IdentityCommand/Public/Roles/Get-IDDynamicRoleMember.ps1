function Get-IDDynamicRoleMember {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Excel','CsvAsAttachmentFile')]
        $Format,

        [Parameter(Mandatory = $true)]
        [ValidateSet('All','Active')]
        $MemberSet,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Excel','CsvAsAttachmentFile')]
        $ReportPath = "/lib/dynamic_role_scripts/export_users/export_dynamic_role_members.report"

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call
        $body = [ordered]@{

            "RoleName"   = $Name
            "Format"     = $Format
            "MemberSet"  = $MemberSet
            "ReportPath" = $ReportPath

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/ExportDynamicRoleMembers"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($body | ConvertTo-Json -Depth 6)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    } #process

    END {} #end
}
