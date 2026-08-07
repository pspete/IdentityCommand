---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDImportedAccountsLog

## SYNOPSIS
Download an imported accounts log file

## SYNTAX

```
Get-IDImportedAccountsLog [-FileKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Downloads the log file produced by an account import job.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDImportedAccountsLog -FileKey 'somefilekey'
```

Downloads the specified import log file.

## PARAMETERS

### -FileKey
The unique key of the import log file to download.

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
