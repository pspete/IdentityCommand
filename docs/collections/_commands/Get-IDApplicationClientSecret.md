---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDApplicationClientSecret

## SYNOPSIS
Get the OpenID Connect client secret for an application

## SYNTAX

```
Get-IDApplicationClientSecret [-ID] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the OpenID Connect client secret for an OIDC web application. Kept separate from `Get-IDApplication` since it returns sensitive credential data.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplicationClientSecret -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the OIDC client secret for the specified application.

## PARAMETERS

### -ID
The unique ID of the OIDC web application.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid, AppKey

Required: True
Position: 0
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
