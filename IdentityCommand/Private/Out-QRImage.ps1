function Out-QRImage {
    <#
	.SYNOPSIS
	Writes a Base 64 Image to a file

	.DESCRIPTION
	Takes a Base 64 encoded QR Code from a CyberArk Identity MFA Mechanism reponse and writes it to a HTML file.

	.PARAMETER Image
	CyberArk Identity base 64 encoded QR image

	.PARAMETER Path
	Output folder for the file.
	Defaults to $ENV:TEMP

	.EXAMPLE
	Out-QRImage -Image $result

	#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        $Image,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$Path
    )

    Begin { }

    Process {

        If (-not ($Path)) {

            #Default to TEMP if path not provided
            $Path = [Environment]::GetEnvironmentVariable('Temp')

        }

        #Get filename from Content-Disposition Header element.
        $FileName = "$Script:SessionId.html"

        #Define output path
        $OutputPath = Join-Path $Path $FileName

        if ($PSCmdlet.ShouldProcess($OutputPath, 'Save File')) {

            try {

                $htmlParams = @{
                    Body = '<IMG SRC="' + $Image + '">'
                }

                #Output base64 image to webpage
                ConvertTo-Html @htmlParams | Out-File $OutputPath

                #return file object
                Get-Item -Path $OutputPath

            } catch {

                #throw the error
                $PSCmdlet.ThrowTerminatingError(

                    [System.Management.Automation.ErrorRecord]::new(

                        "Error Saving $OutputPath",
                        $null,
                        [System.Management.Automation.ErrorCategory]::NotSpecified,
                        $PSItem

                    )

                )
            }

        }

    }

    End { }

}