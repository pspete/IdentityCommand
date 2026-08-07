---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDRecentImportedAccountsFile

## SYNOPSIS
Get details of recently uploaded account import files

## SYNTAX

```
Get-IDRecentImportedAccountsFile [[-FileCount] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns details of recently uploaded account import files.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDRecentImportedAccountsFile -FileCount 5
```

Returns details of the 5 most recently uploaded import files.

## PARAMETERS

### -FileCount
The maximum number of recent files to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
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
