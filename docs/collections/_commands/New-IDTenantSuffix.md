---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDTenantSuffix

## SYNOPSIS
Create a new tenant suffix

## SYNTAX

```
New-IDTenantSuffix [-alias] <Object> [[-cdsAlias] <Object>] [-domain] <Object> [[-directory] <Object>]
 [[-oldname] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new directory suffix (alias) for the tenant and maps it to a domain, for either Cloud Directory (CDS) or AD/Federated Directory Services (AD&FDS) users. Suffixes let a user's login name be qualified with the tenant's own alias rather than the underlying directory's native domain.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDTenantSuffix -alias corp.example.com -domain example.local -directory AD&FDS
```

Create a new AD/FDS suffix that maps the corp.example.com alias to the example.local domain

## PARAMETERS

### -alias
The new tenant Suffix

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -cdsAlias
Boolean if it is a Cloud directory alias

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -domain
The suffix to be mapped to the new suffix

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -directory
Whether or not its mapping the new suffix to CDS users or AD/FDS users

```yaml
Type: Object
Parameter Sets: (All)
Aliases: jsutil-radio2

Required: False
Position: 4
Default value: AD&FDS
Accept pipeline input: False
Accept wildcard characters: False
```

### -oldname
Old name, not sure what this does.
Perhaps for updating an existing alias

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
