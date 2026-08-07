---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDWorkflowJob

## SYNOPSIS
Get workflow jobs

## SYNTAX

### All (Default)
```
Get-IDWorkflowJob [-Type <String>] [<CommonParameters>]
```

### Mine
```
Get-IDWorkflowJob [-Mine] [-Type <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns workflow jobs. By default returns all jobs visible to the caller; with -Mine, returns only
jobs owned by the current user.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDWorkflowJob
```

Returns all workflow jobs.

### Example 2
```powershell
PS C:\> Get-IDWorkflowJob -Mine
```

Returns the current user's workflow jobs.

## PARAMETERS

### -Mine
Return only jobs owned by the current user, instead of all jobs.

```yaml
Type: SwitchParameter
Parameter Sets: Mine
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Filters jobs to a specific job type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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
