---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDAuthenticationProfile

## SYNOPSIS
Get authentication profiles

## SYNTAX

```
Get-IDAuthenticationProfile [[-Name] <Object>] [<CommonParameters>]
```

## DESCRIPTION
By default, returns a decorated (summary) list of all authentication profiles configured in the tenant.
Specify -Name (or its alias -Uuid) to fetch the full details of a specific authentication profile by its unique ID.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDAuthenticationProfile
```

Return all authentication profiles.

### Example 2
```
PS C:\> Get-IDAuthenticationProfile -Name 1234-abcd-5678-efgh
```

Return the full details of the authentication profile with the matching ID.

## PARAMETERS

### -Name
The unique ID (Uuid) of the authentication profile to get details of.
Omit to return all authentication profiles.
Also aliased as Uuid.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Uuid

Required: False
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
