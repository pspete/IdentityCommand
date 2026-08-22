---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDApplicationIcon

## SYNOPSIS
Upload a personal application icon

## SYNTAX

```
Set-IDApplicationIcon [-AppKey] <String> [-Path] <String> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Uploads a custom icon for a self-service "Personal App" (an app a user has added themselves via the User Portal), identified by its Personal App key. Confirmed live end-to-end.

## EXAMPLES

### Example 1
```powershell
PS C:\> $AppKey = (Get-IDUserPortalData).apps | Where-Object Personal -eq $true | Select-Object -First 1 -ExpandProperty AppKey
PS C:\> Set-IDApplicationIcon -AppKey $AppKey -Path 'C:\Icons\someapp.png'
```

Uploads a custom icon for the specified personal application.

## PARAMETERS

### -AppKey
The Personal App's key, in the form `@~/apps/imported_<Name>_<uuid>` - not a plain application `_RowKey`/UUID. Retrieve it from `(Get-IDUserPortalData).apps`, filtering for `Personal -eq $true`; the value is available under both `.AppKey` and `._RowKey`. This does not accept an admin-managed catalog application's key (see `Get-IDApplication`).

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

### -Path
Path to the local image file to upload. The image must be at least 512 bytes, no more than 1 MB, no larger than 1024x1024, and one of .png, .jpg, .ico, .gif (non-animated), or .bmp.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
