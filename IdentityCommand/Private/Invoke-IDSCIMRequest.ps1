function Invoke-IDSCIMRequest {
	<#
	.SYNOPSIS
	Shared helper for calling the tenant's SCIM (System for Cross-domain Identity Management) endpoints

	.DESCRIPTION
	Builds the /scim/<Resource>[/<ID>] URI for the given SCIM resource type and dispatches the
	request via Invoke-IDRestMethod, so individual SCIM Public commands only need to supply the
	resource name, HTTP method, optional resource ID, and optional body. A collection request (no
	-ID) returns a SCIM ListResponse envelope (schemas/totalResults/itemsPerPage/startIndex/
	Resources) - this is flattened to just the Resources array before being returned.

	.PARAMETER Resource
	The SCIM resource collection name, e.g. 'Users', 'Groups', 'Containers'.

	.PARAMETER Method
	The HTTP method to use - GET, POST, PUT, PATCH or DELETE.

	.PARAMETER ID
	The unique ID of a specific resource instance. When supplied, the request targets
	/scim/<Resource>/<ID> instead of the /scim/<Resource> collection.

	.PARAMETER Body
	A hashtable representing the SCIM resource/patch document to send as the request body.

	.EXAMPLE
	Invoke-IDSCIMRequest -Resource 'Users' -Method 'GET'

	Queries all SCIM Users.

	.EXAMPLE
	Invoke-IDSCIMRequest -Resource 'Users' -Method 'DELETE' -ID 'someuserid'

	Deletes the specified SCIM User.

	#>
	[CmdletBinding()]
	param(
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$Resource,

		[parameter(Mandatory = $true)]
		[ValidateSet('GET', 'POST', 'PUT', 'PATCH', 'DELETE')]
		[String]$Method,

		[parameter(Mandatory = $false)]
		[ValidateNotNullOrEmpty()]
		[String]$ID,

		[parameter(Mandatory = $false)]
		[Hashtable]$Body
	)

	BEGIN {}#begin

	PROCESS {

		$URI = "$($ISPSSSession.tenant_url)/scim/$Resource"

		if ($PSBoundParameters.ContainsKey('ID')) {

			$URI = "$URI/$($ID | Get-EscapedString)"

		}

		$Request = @{
			'URI'    = $URI
			'Method' = $Method
		}

		if ($PSBoundParameters.ContainsKey('Body')) {

			$Request['Body'] = ($Body | ConvertTo-Json -Depth 10)

		}

		#Send Request
		$Result = Invoke-IDRestMethod @Request

		#A collection request (no -ID) returns a SCIM ListResponse envelope
		#(schemas/totalResults/itemsPerPage/startIndex/Resources) - flatten to just the resources
		if ($null -ne $Result.Resources) {

			return $Result.Resources

		}

		return $Result

	}#process

	END {}#end

}
