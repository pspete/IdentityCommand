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
            $Path = [System.IO.Path]::GetTempPath()

        }

        #Get filename from Content-Disposition Header element.
        $FileName = "$Script:SessionId.html"

        #Define output path
        $OutputPath = Join-Path $Path $FileName

        if ($PSCmdlet.ShouldProcess($OutputPath, 'Save File')) {

            try {

                $htmlParams = @{
                    Title = 'IdentityCommand Authentication'
                    Head  = '<style>
body {background-color:#ffffff;background-repeat:no-repeat;background-position:top left;background-attachment:fixed;}
h1 {text-align:center;font-family:Helvetica, sans-serif;color:#000000;background-color:#ffffff;}
p {text-align:center;font-family:Helvetica, sans-serif;font-size:14px;font-style:normal;font-weight:normal;color:#000000;background-color:#ffffff;}
</style>'
                    Body  = '<h1>IdentityCommand QR Code Authentication</h1>
    <p>To satisfy the authentication challenge for CyberArk Identity via the IdentityCommand module, scan the QR code with the CyberArk Identity App on your enrolled mobile device.</p>
    <p><img src="' + $Image + '"></p>'

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