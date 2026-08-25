---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDSecuredItem

## SYNOPSIS
Get the current user's secured items

## SYNTAX

```
Get-IDSecuredItem [<CommonParameters>]
```

## DESCRIPTION
Returns the current user's secured items (self-service passwords and secure notes added via the User Portal) along with the tags used to organize them.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDSecuredItem
```

Returns all of the current user's secured items and tags.

### Example 2
```powershell
PS C:\> (Get-IDSecuredItem).SecuredItems | Where-Object SecuredItemType -eq 'Password'
```

Returns only the secured items that are passwords (as opposed to secure notes).

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES
The returned object has two properties: `Tags` (each tag's `itemkeys` lists which secured items carry it) and `SecuredItems` (each with an `ItemKey`, usable as `-ItemKey` for `Set-IDSecuredItemIcon`). Each secured item's `Icon`, if present, is replaced with a short summary (e.g. `[image, 19282 bytes]`) rather than the full base64 data, to keep console output readable.

## RELATED LINKS
