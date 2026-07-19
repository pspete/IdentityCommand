---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDAuthenticationPolicyLink

## SYNOPSIS
Get the current authentication policy links (plinks)

## SYNTAX

```
Get-IDAuthenticationPolicyLink [<CommonParameters>]
```

## DESCRIPTION
Retrieve the tenant's current list of authentication policy links ("plinks") - the entries that map authentication policy blocks to roles, collections, or the global scope.
\`New-IDAuthenticationPolicy\` and \`Set-IDAuthenticationPolicy\` use this list as the base set of links when saving a policy block.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDAuthenticationPolicyLink
```

Return the tenant's current authentication policy links.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
