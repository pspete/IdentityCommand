---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Remove-IDAuthenticationPolicyBlock

## SYNOPSIS
Delete an authentication policy block

## SYNTAX

```
Remove-IDAuthenticationPolicyBlock [-Name] <Object> [<CommonParameters>]
```

## DESCRIPTION
Delete an authentication policy block from the tenant by its policy path.
-Name must be supplied in the \`/Policy/<PolicyName>\` path syntax; if it isn't, the command warns and stops without calling the API.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-IDAuthenticationPolicyBlock -Name '/Policy/Default Policy'
```

Delete the authentication policy block at the specified policy path.

## PARAMETERS

### -Name
The path of the authentication policy block to delete, in the syntax \`/Policy/<PolicyName>\`. Also aliased as PolicySet. Accepts pipeline input by property name.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: PolicySet

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
