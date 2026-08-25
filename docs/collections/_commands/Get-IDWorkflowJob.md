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
Get-IDWorkflowJob [-Type <String>] [-PageNumber <Int32>] [-PageSize <Int32>] [<CommonParameters>]
```

### Mine
```
Get-IDWorkflowJob [-Mine] [-Type <String>] [-PageNumber <Int32>] [-PageSize <Int32>] [<CommonParameters>]
```

### JobId
```
Get-IDWorkflowJob [-JobId] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns workflow jobs. With `-JobId`, returns a single job by ID. Otherwise, by default returns all jobs tenant-wide (`/JobFlow/GetJobs`, `-Type` must be `all` there - the server rejects `approve`/`request` on this endpoint); with `-Mine`, returns only jobs visible to the current user - everything they've been involved in (`-Type 'all'`, the default), specifically what's awaiting their approval (`-Type 'approve'`), or their own still-pending requests (`-Type 'request'`).

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDWorkflowJob
```

Returns all workflow jobs tenant-wide.

### Example 2
```powershell
PS C:\> Get-IDWorkflowJob -Mine -Type 'approve'
```

Returns jobs awaiting the current user's approval.

### Example 3
```powershell
PS C:\> Get-IDWorkflowJob -JobId '619e74f9-bc7e-43a0-8f95-40c2292a347a'
```

Returns the specified job.

## PARAMETERS

### -JobId
The unique ID of a single job to retrieve.

```yaml
Type: String
Parameter Sets: JobId
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Mine
Return only jobs visible to the current user, instead of all jobs tenant-wide.

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
Which subset of jobs to return - `all`, `approve`, or `request`. Defaults to `all`. `approve`/`request` are only valid with `-Mine` - the tenant-wide endpoint only supports `all` and throws locally if given anything else.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: all
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageNumber
The page of results to return. Defaults to `1`.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
The number of results per page. Defaults to `100`.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
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
