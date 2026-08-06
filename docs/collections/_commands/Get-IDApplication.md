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
Returns the details of a single application, identified either by its unique ID or by its service name.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplication -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the application with the specified ID.

### Example 2
```powershell
PS C:\> Get-IDApplication -ServiceName 'SomeApp'
```

Returns the ID of the application matching the specified service name.

## PARAMETERS

### -ID
The unique ID of the application to retrieve.

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
The service name of the application to look up.

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
