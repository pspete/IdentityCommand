---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDAuthenticationPolicy

## SYNOPSIS
Create a new authentication policy

## SYNTAX

```
New-IDAuthenticationPolicy [-PolicyName] <Object> [[-Description] <Object>] [[-LinkType] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Create a new authentication policy block in the tenant with the specified name, description, and link type.
The new policy is added to the tenant's existing set of policy links (plinks) and saved with a default priority of 1 and no filters or conditions configured; use \`Set-IDAuthenticationPolicy\` afterwards to update it once conditions are needed.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDAuthenticationPolicy -PolicyName 'Default Policy'
```

Create a new global authentication policy named "Default Policy".

### Example 2
```powershell
PS C:\> New-IDAuthenticationPolicy -PolicyName 'Sales Role Policy' -Description 'MFA policy for the Sales role' -LinkType Role
```

Create a new authentication policy intended to be linked to a role, with a description.

## PARAMETERS

### -Description
A free-text description of the authentication policy. Defaults to an empty string.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinkType
The scope the policy link applies to: Global (applies tenant-wide), Role (applies when linked to a specific role), or Collection (applies when linked to an application/resource collection). Defaults to Global.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: Role, Global, Collection

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyName
The name of the new authentication policy. This becomes the policy's path, \`/Policy/<PolicyName>\`.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
