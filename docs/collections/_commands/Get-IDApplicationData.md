---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDApplicationData

## SYNOPSIS
Get an application's user portal data

## SYNTAX

```
Get-IDApplicationData [-AppKey] <String> [[-MarkAppVisited] <Boolean>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns an application's data as shown in the user portal, optionally marking it as visited.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplicationData -AppKey 'someappkey'
```

Returns the specified application's portal data.

## PARAMETERS

### -AppKey
The unique key of the application.

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

### -MarkAppVisited
Whether to mark the application as visited. Defaults to $false.

```yaml
Type: Boolean
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
