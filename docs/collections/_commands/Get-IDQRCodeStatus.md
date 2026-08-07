---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDQRCodeStatus

## SYNOPSIS
Get QR code authentication status

## SYNTAX

```
Get-IDQRCodeStatus [-Guid] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the status of an in-progress QR code authentication session for the given client GUID.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDQRCodeStatus -Guid 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the QR code session status for the specified GUID.

## PARAMETERS

### -Guid
The client GUID identifying the QR code session, as generated for the session by
New-IDQRCodeSession.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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
