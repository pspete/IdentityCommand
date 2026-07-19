---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDAuthenticationPolicyBlock

## SYNOPSIS
Get an authentication policy block by name

## SYNTAX

```
Get-IDAuthenticationPolicyBlock [-Name] <Object> [<CommonParameters>]
```

## DESCRIPTION
Retrieve a specific authentication policy block (a named authentication policy rule set) along with its current version and revision stamp.
This is used internally by \`Set-IDAuthenticationPolicy\` to look up the \`Version\`/\`RevStamp\` of a policy before saving changes to it.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDAuthenticationPolicyBlock -Name 'Default Policy'
```

Return the policy block matching the specified name.

## PARAMETERS

### -Name
The name of the authentication policy block to retrieve. Also aliased as PolicySet. Accepts pipeline input by property name.

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
