---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUser

## SYNOPSIS
Fetch details of cloud directory users

## SYNTAX

### GetUsers (Default)
```
Get-IDUser [<CommonParameters>]
```

### GetUser
```
Get-IDUser -ID <String> [<CommonParameters>]
```

### GetUserByName
```
Get-IDUser -username <String> [<CommonParameters>]
```

### GetUserAttributes
```
Get-IDUser [-CurrentUser] [<CommonParameters>]
```

## DESCRIPTION
By default, returns details of all existing users in the cloud directory.

Specify \`id\` or \`username\` parameter to to fetch the details of a specific existing user in the cloud directory.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDUser
```

Return all users

### Example 2
```
PS C:\> Get-IDUser -id 1234-abcd-5678-efgh
```

Return user with matching id

### Example 3
```
PS C:\> Get-IDUser -username someuser@somedomain.com
```

Return user with matching username

### Example 4
```
PS C:\> Get-IDUser -CurrentUser
```

Return details of current authenticated user

## PARAMETERS

### -username
The username of the user to get details of

```yaml
Type: String
Parameter Sets: GetUserByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ID
The id of the user to get details of

```yaml
Type: String
Parameter Sets: GetUser
Aliases: Uuid

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CurrentUser
Specify to return details of authenticated user

```yaml
Type: SwitchParameter
Parameter Sets: GetUserAttributes
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
