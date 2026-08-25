# .ExternalHelp IdentityCommand-help.xml
function Set-IDUserPhonePin {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$PhonePin
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Set User Phone PIN')) {

            $Body = [ordered]@{
                'ID'       = $ID
                'phonepin' = $PhonePin
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/SetPhonePin"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
