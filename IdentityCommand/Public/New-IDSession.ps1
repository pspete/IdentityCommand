# .ExternalHelp IdentityCommand-help.xml
Function New-IDSession {

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Actual legitimate use of Write-Host')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        #tenant_url
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$tenant_url,

        #User Creds
        [Parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential

    )

    Begin {

        #Remove WebSession which may exist in module scope
        Remove-Variable -Name WebSession -Scope Script -ErrorAction SilentlyContinue

        $LogonRequest = @{ }
        $LogonRequest['Method'] = 'POST'
        $LogonRequest['SessionVariable'] = 'IDSession'

    }

    Process {

        #Ensure URL is in expected format
        #Remove trailing space if provided in Url
        $tenant_url = $tenant_url -replace '/$', ''

        #Set Module Scope variables
        Set-Variable -Name tenant_url -Value $tenant_url -Scope Script
        Set-Variable -Name Version -Value '1.0' -Scope Script

        $LogonRequest['Headers'] = @{'accept' = '*/*' }

        #*Start Authentication
        $IDSession = $LogonRequest | Start-Authentication -Credential $Credential

        #Set request properties for Advance.
        $LogonRequest.Remove('SessionVariable')
        $LogonRequest['Headers'].Add('X-IDAP-NATIVE-CLIENT', $true)

        #Set Module Scope variables
        Set-Variable -Name TenantId -Value $IDSession.TenantId -Scope Script
        Set-Variable -Name SessionId -Value $IDSession.SessionId -Scope Script

        #The MFA Bit - keep a reference to $IDSession for the MFA Package
        $ThisSession = $IDSession
        for ($Challenge = 0; $Challenge -lt $(($ThisSession.Challenges).Count); $Challenge++) {

            #Iterate through presented challenges
            if ($($IDSession.Summary) -eq 'NewPackage') {

                #Initialise loop and $ThisSession if NewPackage Challenges are presented
                $Challenge = 0
                $ThisSession = $IDSession
                if ($null -ne $ThisSession.EventDescription) { Write-Warning -Message $ThisSession.EventDescription }

            }

            #Get Current Challenge Mechanisms
            $Mechanisms = $ThisSession.Challenges[$Challenge] | Select-Object -ExpandProperty Mechanisms

            #select challenge mechanism
            $Mechanism = Select-ChallengeMechanism -Mechanisms $Mechanisms

            try {

                #answer challenge mechanism
                $Answer = Get-MechanismAnswer -Mechanism $Mechanism -Credential $Credential

                #*Advance Authentication
                $IDSession = $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer $Answer

            } catch {

                throw $PSItem

            }

            if ($($IDSession.Summary) -eq 'NewPackage') {

                #New Package Recieved, decrement counter so we go round the loop again to evaluate.
                $Challenge--

            }

        }

        switch ($IDSession.Summary) {

            'NoncommitalSuccess' {
                Write-Host $IDSession.ClientMessage
                break
            }

            default {

                if ($null -ne $IDSession) {

                    $IDSession | Select-Object -Last 1 | Add-CustomType -Type IdCmd.ID.Session

                }

                break

            }

        }

    } #process

    End { } #end

}