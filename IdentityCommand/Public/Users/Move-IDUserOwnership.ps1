# .ExternalHelp IdentityCommand-help.xml
function Move-IDUserOwnership {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'TargetUser')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'ID')]
        [String[]]$Users,

        [parameter(Mandatory = $true, ParameterSetName = 'TargetUser')]
        [ValidateNotNullOrEmpty()]
        [String]$TargetUser,

        [parameter(Mandatory = $true, ParameterSetName = 'TransferToManager')]
        [Switch]$TransferToManager
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess(($Users -join ', '), 'Transfer Ownership')) {

            $Body = [ordered]@{
                'Users'             = @($Users)
                'TransferToManager' = $TransferToManager.IsPresent
                'TargetUser'        = $TargetUser
            }

            #Constructed body for the rest call
            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/TransferOwnership"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
