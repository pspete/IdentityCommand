---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDSecuredItemImportFile

## SYNOPSIS
Get details of recently uploaded secured item import files

## SYNTAX

```
Get-IDSecuredItemImportFile [-FileCount] <Int32>
 [<CommonParameters>]
```

## DESCRIPTION
Returns details of recently uploaded secured item (credential) import files, including each job's status and the `RowKey` needed by `Get-IDSecuredItemImportLog`.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDSecuredItemImportFile -FileCount 5
```

Returns details of the 5 most recently uploaded import files.

## PARAMETERS

### -FileCount
The maximum number of recent files to return. Required - a call with no `-FileCount` fails
server-side with a generic error page.

```yaml
Type: Int32
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
