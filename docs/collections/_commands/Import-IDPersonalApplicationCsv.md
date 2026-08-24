---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Import-IDPersonalApplicationCsv

## SYNOPSIS
Bulk import personal applications (credentials) from a CSV file

## SYNTAX

```
Import-IDPersonalApplicationCsv [-Path] <String> [-SkipIfAppExists <Boolean>] [-SkipSharedFolders <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Imports personal applications (self-service password entries, appearing under the `@~/apps/...` key space alongside browser-extension-captured apps) from a local CSV file matching the generic import template's column layout (`name`, `url`, `username`, `password`, `notes`, `totp`, `folder`), validating then committing the import in a single command.

Only the generic template is supported - importing a provider-native export (LastPass, Dashlane, Google, KeePass, etc.) needs that provider's own column layout, which isn't yet confirmed.

The immediate response doesn't confirm what was actually created - check `Get-IDPersonalApplicationImportFile`'s `SuccessRecords`/`SkippedRecords`/`FailedRecords` for the real outcome once the job completes.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-IDPersonalApplicationCsv -Path .\export.csv
```

Validates and imports the personal applications in 'export.csv'.

## PARAMETERS

### -Path
Path to the local CSV file to import.

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

### -SkipIfAppExists
Whether to skip an item if a matching app already exists. Confirmed live: the server's "existing" match can be broad enough to skip an entire batch of otherwise-new items, so this defaults to `$false` rather than the UI's default of `$true`.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipSharedFolders
Whether to skip shared folders.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
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
