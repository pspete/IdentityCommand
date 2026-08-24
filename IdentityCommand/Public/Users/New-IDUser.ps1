# .ExternalHelp IdentityCommand-help.xml
function New-IDUser {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory = $true)]
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
        [SecureString]$Password,

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
        [String]$PrimaryIdentifier,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$CmaRedirectedUserUuid,

        [parameter(Mandatory = $false)]
        [Switch]$ServiceUser,

        [parameter(Mandatory = $false)]
        [Switch]$InEverybodyRole,

        [parameter(Mandatory = $false)]
        [Switch]$InSysAdminRole,

        [parameter(Mandatory = $false)]
        [Switch]$SendEmailInvite,

        [parameter(Mandatory = $false)]
        [Switch]$SendSmsInvite,

        [parameter(Mandatory = $false)]
        [Switch]$VerifyEmail,

        [parameter(Mandatory = $false)]
        [Switch]$ForcePasswordChangeNext,

        [parameter(Mandatory = $false)]
        [Switch]$PasswordNeverExpire,

        #Matches the underlying API field name exactly (lowercase 'u') so the request body can be
        #built directly from bound parameter names, consistent with the existing -username
        #parameter on Get-IDUser.
        [parameter(Mandatory = $false)]
        [Switch]$useAlternateMfaAccount
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, 'Create User')) {

            #Build body from all bound parameters except Password, which needs decoding first
            $Body = $PSBoundParameters | Get-Parameter -ParametersToRemove Password

            if ($PSBoundParameters.ContainsKey('Password')) {

                $Body['Password'] = ConvertTo-InsecureString -SecureString $Password

            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/CreateUser"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
