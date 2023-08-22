---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDPlatformToken

## SYNOPSIS
Request authentication token using OAuth

## SYNTAX

```
New-IDPlatformToken [-tenant_url] <String> [-Credential] <PSCredential> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Gets a CyberArk Identity Security Platform OIDC token based on grant type.

## EXAMPLES

### Example 1
```
PS C:\> New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
```

Initiates OAuth confidential client service user authentication to specified tenant

## PARAMETERS

### -tenant_url
The URL of the CyberArk Identity tenant to authenticate to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Credential
Credential object containing username and password of a service user that is an OAuth confidential client to authenticate to CyberArk Identity.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Default value: False
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
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
