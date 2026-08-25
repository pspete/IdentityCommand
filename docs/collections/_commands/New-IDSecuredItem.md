---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDSecuredItem

## SYNOPSIS
Create a new secured item

## SYNTAX

```
New-IDSecuredItem [-Name] <String> [-SecuredItemType] <String> [[-Description] <String>] [[-Username] <String>] [[-Password] <SecureString>] [[-Notes] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new self-service secured item (a password or secure note added via the User Portal) owned by the current user.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDSecuredItem -Name 'ZZZ-test' -SecuredItemType 'Password' -Username 'someuser' -Password (ConvertTo-SecureString 'somepassword' -AsPlainText -Force)
```

Creates a new password-type secured item and returns its new ItemKey.

### Example 2
```powershell
PS C:\> New-IDSecuredItem -Name 'ZZZ-test-note' -SecuredItemType 'SecureNote' -Notes 'Some note content'
```

Creates a new secure-note-type secured item and returns its new ItemKey.

## PARAMETERS

### -Name
The display name of the secured item.

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

### -SecuredItemType
The type of secured item to create - 'Password' or 'SecureNote'. For 'SecureNote', use `-Notes` instead of `-Username`/`-Password`.

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

### -Description
A description of the secured item.

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

### -Username
The username to store, for a 'Password'-type secured item.

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

### -Password
The password to store, for a 'Password'-type secured item.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
The note content, for a 'SecureNote'-type secured item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

### None
## OUTPUTS

### System.String
The new secured item's ItemKey, as a plain string.
## NOTES

## RELATED LINKS
