---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDApplication

## SYNOPSIS
Get details of an application

## SYNTAX

### ID (Default)
```
Get-IDApplication -ID <String> [<CommonParameters>]
```

### ServiceName
```
Get-IDApplication -ServiceName <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the details of a single application, identified either by its row key or by its service name.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplication -ID 'SomeApplicationName'
```

Returns the application matching the specified name/row key.

### Example 2
```powershell
PS C:\> Get-IDApplication -ServiceName 'SomeApp'
```

Returns the application matching the specified service name. Internally, this resolves the service name to an application ID and then fetches its full details, so the result is the same shape as the `-ID` parameter set.

## PARAMETERS

### -ID
The name or app key (row key) of the application to retrieve. Fetch the app key from the Admin Portal after adding an application, or via a Redrock query. This cannot be the Application Id value for OAuth/OIDC-type applications - use the application's name instead for those.

```yaml
Type: String
Parameter Sets: ID
Aliases: Uuid, AppKey

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServiceName
The service name of the application to look up (relevant for OAuth2/OIDC-type applications, which may not have a usable `_RowKey`).

```yaml
Type: String
Parameter Sets: ServiceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
