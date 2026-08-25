# .ExternalHelp IdentityCommand-help.xml
function Get-IDOrganizationMember {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        #Escape embedded single quotes before interpolating into the query
        $EscapedID = $ID -replace "'", "''"

        Invoke-IDSqlcmd -Script "SELECT ID as Guid, Username, DisplayName FROM User WHERE OrgId = '$EscapedID'"

    }#process

    END {}#end

}
