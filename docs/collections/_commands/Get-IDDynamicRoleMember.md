---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDDynamicRoleMember

## SYNOPSIS
Export the members of a dynamic role

## SYNTAX

```
Get-IDDynamicRoleMember [-Name] <Object> [-Format] <Object> [-MemberSet] <Object> [[-ReportPath] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
Generates and returns an export of the members of a dynamic (script-based) role, whose membership is computed at query time rather than being a fixed principal list.
Use -MemberSet to scope the export to all matched members or only active ones, and -Format to choose the export format.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDDynamicRoleMember -Name 'Dynamic Role' -Format CsvAsAttachmentFile -MemberSet Active
```

Export the active members of the dynamic role as a CSV attachment

## PARAMETERS

### -Format
The format to export the dynamic role members in.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: Excel, CsvAsAttachmentFile

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberSet
Whether to export all members matched by the dynamic role's script (\`All\`) or only currently active members (\`Active\`).

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: All, Active

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name (or ID) of the dynamic role to export members for.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReportPath
The path of the report definition script used to generate the export.
Defaults to the built-in \`/lib/dynamic_role_scripts/export_users/export_dynamic_role_members.report\` report; override only if a custom report script is used.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: Excel, CsvAsAttachmentFile

Required: False
Position: 3
Default value: None
Accept pipeline input: False
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
