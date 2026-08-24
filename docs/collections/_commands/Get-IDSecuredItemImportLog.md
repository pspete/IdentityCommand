---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDSecuredItemImportLog

## SYNOPSIS
Download an imported secured item log file

## SYNTAX

```
Get-IDSecuredItemImportLog [-FileKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Downloads and parses the CSV log file produced by a secured item (credential) import job, returning one object per imported row.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDSecuredItemImportLog -FileKey 'somefilekey'
```

Downloads and parses the specified import log file.

## PARAMETERS

### -FileKey
The unique key of the import log file to download - the `RowKey` from `Get-IDSecuredItemImportFile`.

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
