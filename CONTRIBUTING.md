# Contributing

All contributions, whether comments, code or otherwise are welcomed and appreciated.

## IdentityCommand Issues

If you find an error in `IdentityCommand`, or have a question relating to the module, [log an issue][new-issue].

## Contributing Code

- Fork the repo.
- Push your changes to your fork.
- Write [good commit messages][commit]
  - use of emojis are encouraged.
- If no related issue exists already, open a [New Issue][new-issue] describing the problem being fixed or feature.
- [Update documentation](#updating-documentation) for the command as required.
- Submit a pull request to the [Dev Branch][dev-branch]
  - Keep pull requests limited to a single issue
  - Discussion, or necessary changes may be needed before merging the contribution.
  - Link the pull request to the related issue

### PowerShell Styleguide

Use the standard *Verb*-*Noun* convention, and only use approved verbs.

[K&R (One True Brace Style variant)](https://github.com/PoshCode/PowerShellPracticeAndStyle/issues/81) preferred.

## Updating Documentation

### External Help File

[Command Help][command-help] Markdown files are the source of truth for the `Get-Help` content of the module.

Changes to these markdown files must be reflected in the `Get-Help` content.

`platyPS` must be used to automatically generate the external help file:

```powershell
#From the module root directory, run:
import-module platyPS
New-ExternalHelp -Path .\docs\collections\_commands\ -OutputPath .\IdentityCommand\en-US\IdentityCommand-help.xml -Force
```

[commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[OTBS]: https://github.com/PoshCode/PowerShellPracticeAndStyle/issues/81
[new-issue]: https://github.com/pspete/IdentityCommand/issues/new
[dev-branch]: https://github.com/pspete/IdentityCommand/tree/dev
[command-help]: https://github.com/pspete/IdentityCommand/tree/master/docs/collections/_commands