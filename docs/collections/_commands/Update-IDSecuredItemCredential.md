---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Update-IDSecuredItemCredential

## SYNOPSIS
Update credentials for a secured item

## SYNTAX

```
Update-IDSecuredItemCredential [-ItemKey] <String> [[-Username] <String>] [[-Password] <SecureString>]
 [[-CustomFields] <Hashtable[]>] [[-Notes] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates the stored credentials for a secured item.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Password = ConvertTo-SecureString 'SomePassword123' -AsPlainText -Force
PS C:\> Update-IDSecuredItemCredential -ItemKey 'someitemkey' -Username 'someuser' -Password $Password
```

Updates the credentials for the specified secured item.

### Example 2
```powershell
PS C:\> Update-IDSecuredItemCredential -ItemKey 'someitemkey' -CustomFields @{ Key = 'Environment'; Value = 'Production' }, @{ Key = 'Secret'; Value = 'hidden-value'; Hidden = $true }
```

Sets two custom fields on the secured item, hiding the value of the second.

## PARAMETERS

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

### -CustomFields
Custom field data for the secured item. Each entry is `@{Key='<name>'; Value='<value>'; Hidden=$true/$false}` - `Hidden` defaults to `$false` if omitted.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ItemKey
The unique key of the secured item.

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

### -Notes
Free-text notes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password to store.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username to validate or associate with the credentials.

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
