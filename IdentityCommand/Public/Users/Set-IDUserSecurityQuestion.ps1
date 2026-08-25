# .ExternalHelp IdentityCommand-help.xml
function Set-IDUserSecurityQuestion {
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
        [Array]$Added = @(),

        [parameter(Mandatory = $false)]
        [Array]$Deleted = @(),

        [parameter(Mandatory = $false)]
        [Switch]$Replace
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Set User Security Questions')) {

            $Body = [ordered]@{
                'Id'      = $ID
                'Added'   = $Added
                'Deleted' = $Deleted
                'Replace' = [Bool]$Replace
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/UpdateSecurityQuestions"
                'Method' = 'POST'
                #Sent as raw UTF8 bytes rather than a String so ParameterBinding/module logging of
                #this call records a non-revealing type name instead of the literal request content
                'Body'   = [System.Text.Encoding]::UTF8.GetBytes($($Body | ConvertTo-Json -Depth 6))

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}
