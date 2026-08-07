---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Test-IDApplicationUsername

## SYNOPSIS
Test whether a username is allowed for an app or item

## SYNTAX

```
Test-IDApplicationUsername [-Username] <String> [<CommonParameters>]
```

## DESCRIPTION
Validates whether a given username is allowed for an application or secured item.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-IDApplicationUsername -Username 'someuser'
```

Validates whether the specified username is allowed.

## PARAMETERS

### -Username
The username to validate or associate with the credentials.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
