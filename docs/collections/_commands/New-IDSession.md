---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDSession

## SYNOPSIS
Authenticates a user to a CyberArk Identity tenant.

## SYNTAX

```
New-IDSession [-tenant_url] <String> [-Credential] <PSCredential> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Use this command to authenticate to CyberArk Identity.

Allows a user to provide authentication details, and satisfy any required MFA challenges.

Currently supports all authentication mechanisms except U2F & DUO.

## EXAMPLES

### Example 1
```
PS C:\> $Cred = Get-Credential
PS C:\> New-IDSession -tenant_url https://some.tenant.cyberark.cloud -Credential $Cred
```

Initiates authentication to specified tenant, and allows selection and answer of any required MFA challenges.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Credential object containing username and password required to authenticate to CyberArk Identity.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenant_url
The URL of the CyberArk Identity tenant to authenticate to.

```yaml
Type: String
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

### System.String

### System.Management.Automation.PSCredential

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
