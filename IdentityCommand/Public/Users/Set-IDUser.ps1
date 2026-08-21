# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
# TODO: -AccountExp is serialized via the default ConvertTo-Json DateTime handling, which may not
# match the ISO 8601 format ("2019-08-24T14:15:22Z") shown in the recorded sample request - verify
# and adjust (e.g. $AccountExp.ToString('o')) if the API rejects the default serialization.
function Set-IDUser {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Mail,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$DisplayName,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$MobileNumber,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$HomeNumber,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$OfficeNumber,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$OrgPath,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$ReportsTo,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$CmaRedirectedUserUuid,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$PreferredCulture,

        [parameter(Mandatory = $false)]
        [DateTime]$AccountExp,

        [parameter(Mandatory = $false)]
        [Switch]$ServiceUser,

        [parameter(Mandatory = $false)]
        [Switch]$InEverybodyRole,

        [parameter(Mandatory = $false)]
        [Switch]$VerifyEmail,

        [parameter(Mandatory = $false)]
        [Switch]$ForcePasswordChangeNext,

        [parameter(Mandatory = $false)]
        [Switch]$PasswordNeverExpire,

        #Matches the underlying API field name exactly (lowercase 'u') - see New-IDUser.
        [parameter(Mandatory = $false)]
        [Switch]$useAlternateMfaAccount
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Update User')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/ChangeUser"
                'Method' = 'POST'
                'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
