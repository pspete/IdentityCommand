---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUserAttribute

## SYNOPSIS
Fetch attributes for a specified user

## SYNTAX

```
Get-IDUserAttribute [[-ID] <String>] [[-directoryServiceUUID] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns the attributes for a specified user, optionally scoped to a specific directory service.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDUserAttribute -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns attributes for the specified user.

## PARAMETERS

### -ID
The unique ID of the user to get attributes for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -directoryServiceUUID
The unique ID of the directory service to scope the attribute lookup to. Uses lowercase-first casing (rather than standard PowerShell parameter casing) to match the underlying API's query parameter name exactly, consistent with `-username` on `Get-IDUser`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
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
