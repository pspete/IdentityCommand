---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDUserPicture

## SYNOPSIS
Set a user's picture

## SYNTAX

```
Set-IDUserPicture [-ID] <String> [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Uploads an image file as a user's profile picture, then returns the newly-set picture as an object with ContentType, Length, and Bytes properties.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDUserPicture -ID 'a1b2c3d4-0000-0000-0000-000000000000' -Path '.\photo.jpg'
```

Sets the specified user's picture to the given image file.

## PARAMETERS

### -ID
The unique ID of the user to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
The path to the image file to upload. The image must be at least 512 bytes, no more than 1 MB, no larger than 1024x1024, and one of .png, .jpg, .ico, .gif (non-animated), or .bmp.

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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
