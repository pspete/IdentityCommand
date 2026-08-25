---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDTenantSecurityQuestion

## SYNOPSIS
Add a tenant admin security question

## SYNTAX

```
Set-IDTenantSecurityQuestion [-Question] <String> [[-Culture] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a new security question to the set of tenant admin security questions. The underlying API only supports adding a new question - there is no update-by-ID path (use Remove-IDTenantSecurityQuestion followed by Set-IDTenantSecurityQuestion to replace one).

The response carries no ID - use `Get-IDTenantSecurityQuestion` afterward to find the new question's Uuid (needed by `Remove-IDTenantSecurityQuestion`).

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDTenantSecurityQuestion -Question 'What was the name of your first pet?'
```

Adds a new security question with the default culture.

## PARAMETERS

### -Culture
The culture the question applies to. Defaults to 'all'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: all
Accept pipeline input: False
Accept wildcard characters: False
```

### -Question
The text of the security question to add.

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
