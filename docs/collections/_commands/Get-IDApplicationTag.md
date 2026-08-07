---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDApplicationTag

## SYNOPSIS
Get tags for an application

## SYNTAX

```
Get-IDApplicationTag [-AppKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the tags associated with an application.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplicationTag -AppKey 'someappkey'
```

Returns the tags on the specified application.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
