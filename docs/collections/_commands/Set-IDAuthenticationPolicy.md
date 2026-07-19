---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDAuthenticationPolicy

## SYNOPSIS
Update an existing authentication policy

## SYNTAX

```
Set-IDAuthenticationPolicy [-PolicyName] <Object> [[-Description] <Object>] [[-LinkType] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Update an existing authentication policy block identified by -PolicyName.
The command looks up the policy's current \`Version\` and \`RevStamp\` via \`Get-IDAuthenticationPolicyBlock\`, increments the version, and re-saves the policy block with the supplied description and link type.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDAuthenticationPolicy -PolicyName 'Default Policy' -Description 'Updated MFA requirements'
```

Update the description of the existing "Default Policy" authentication policy.

### Example 2
```powershell
PS C:\> Set-IDAuthenticationPolicy -PolicyName 'Sales Role Policy' -LinkType Role
```

Change the link type of the existing "Sales Role Policy" authentication policy to Role.

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
The name of the existing authentication policy to update. Accepts pipeline input by property name.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

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
