---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDApplicationUserCredential

## SYNOPSIS
Set user credentials for an application

## SYNTAX

```
Set-IDApplicationUserCredential [-AppKey] <String> [[-Username] <String>] [[-Password] <SecureString>]
 [[-PublicKeyHash] <String>] [[-ConnectorId] <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets the stored user credentials used to log in to an application.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Password = ConvertTo-SecureString 'SomePassword123' -AsPlainText -Force
PS C:\> Set-IDApplicationUserCredential -AppKey 'someappkey' -Username 'someuser' -Password $Password
```

Sets the login credentials for the specified application.

## PARAMETERS

### -AppKey
The unique key of the application.

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

### -ConnectorId
The ID of the connector to associate with the credentials.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password to store.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PublicKeyHash
The public key hash to associate with the credentials, for key-based authentication.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username to validate or associate with the credentials.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
