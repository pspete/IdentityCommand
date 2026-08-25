# .ExternalHelp IdentityCommand-help.xml
function Get-IDSecuredItem {
    [CmdletBinding()]
    param( )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UPRest/GetSecuredItemsData"
            'Method' = 'POST'
            'Body'   = (@{ 'force' = $true } | ConvertTo-Json)

        }

        #Send Request
        $result = Invoke-IDRestMethod @Request

        if ($null -ne $result) {

            #Each item's Icon is a full base64 data URI (can run to tens of KB) - replace it with a
            #short summary so console output (especially Format-List) stays readable
            $SecuredItems = foreach ($Item in $result.SecuredItems) {

                if ($Item.Icon) {

                    $ImageBytes = $Item.Icon -replace '^data:[^,]*,', ''

                    try {

                        $ByteCount = [Convert]::FromBase64String($ImageBytes).Length
                        $Item.Icon = "[image, $ByteCount bytes]"

                    } catch {

                        $Item.Icon = '[image]'

                    }

                }

                $Item

            }

            #Tags listed first so a long SecuredItems array doesn't push it out of view
            [PSCustomObject]@{
                'Tags'         = $result.Tags
                'SecuredItems' = $SecuredItems
            }

        }

    }#process

    END {}#end

}
