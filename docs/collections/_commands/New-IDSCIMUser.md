---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDSCIMUser

## SYNOPSIS
Create a SCIM User

## SYNTAX

```
New-IDSCIMUser [-Attributes] <Hashtable> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new SCIM User resource.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDSCIMUser -Attributes @{ userName = 'someuser@somedomain.com'; displayName = 'Some User'; schemas = @('urn:ietf:params:scim:schemas:core:2.0:User') }
```

Creates a new SCIM User. `userName` must be in `name@suffix` form.

### Example 2
```powershell
PS C:\> New-IDSCIMUser -Attributes @{
    userName          = 'someuser@somedomain.com'
    displayName       = 'Some User'
    name              = @{ formatted = 'Some User'; familyName = 'User'; givenName = 'Some' }
    preferredLanguage = 'en-US'
    active            = $true
    emails            = @(@{ type = 'work'; primary = $true; value = 'someuser@somedomain.com' })
    phoneNumbers      = @(@{ type = 'mobile'; value = '+15555550100' })
    'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User' = @{ organization = 'Some Org'; manager = @{ value = '<manager-uuid>' } }
    schemas           = @('urn:ietf:params:scim:schemas:core:2.0:User', 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User')
}
```

Creates a new SCIM User with the fuller set of optional fields the resource document supports.

## PARAMETERS

### -Attributes
A hashtable representing the SCIM resource document. See the command examples for the recorded field shape. `userName` must be in `name@suffix` form.

```yaml
Type: Hashtable
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
