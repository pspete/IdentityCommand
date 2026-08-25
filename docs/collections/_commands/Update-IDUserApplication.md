---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Update-IDUserApplication

## SYNOPSIS
Update the current user's application settings

## SYNTAX

```
Update-IDUserApplication [-AppKey] <String> [[-Notes] <String>] [[-UrlMatchDetection] <String>] [[-MatchPattern] <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the current user's notes and/or URL match detection settings for an application.

## EXAMPLES

### Example 1
```powershell
PS C:\> Update-IDUserApplication -AppKey 'someappkey' -Notes 'Updated notes'
```

Updates the current user's notes for an application.

### Example 2
```powershell
PS C:\> Update-IDUserApplication -AppKey 'someappkey' -UrlMatchDetection 'RegularExpression' -MatchPattern '^https://example\.com/.*'
```

Sets the application's URL match detection to a regular expression.

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

### -Notes
Free-text notes.

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

### -UrlMatchDetection
How the application's launch URL is matched - '', 'BaseDomain', 'RegularExpression' (requires `-MatchPattern`), 'ExactMatch', or 'Hostname'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MatchPattern
The pattern to match against, when `-UrlMatchDetection` is 'RegularExpression'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
