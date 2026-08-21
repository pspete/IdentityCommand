---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Start-IDWorkflowJob

## SYNOPSIS
Start a workflow job

## SYNTAX

```
Start-IDWorkflowJob [-Script] <String> [[-Args] <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Starts a background workflow job that runs the specified script. Returns the new job's ID as a plain string.

## EXAMPLES

### Example 1
```powershell
PS C:\> Start-IDWorkflowJob -Script '/lib/get_superrights.js' -Args @{ excludeRight = '' }
```

Starts a workflow job running the specified script, and returns its job ID.

## PARAMETERS

### -Args
A hashtable of named parameters to pass to the script, matching whatever that script expects (e.g. `@{excludeRight=''}` for `/lib/get_superrights.js`).

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

### -Script
The virtual path of the script to run as a job. Must start with a forward slash (e.g. `/lib/get_superrights.js`) - a plain label without a leading `/` is rejected by the server.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
