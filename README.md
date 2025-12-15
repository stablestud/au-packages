[Update status](https://gist.github.com/stablestud/226bf7a893a53f1ee1eda1d3e78bf1bd)
[![](http://transparent-favicon.info/favicon.ico)](#)
[chocolatey/stablestud](https://chocolatey.org/profiles/stablestud)

This repository contains [chocolatey automatic packages](https://chocolatey.org/docs/automatic-packages).  

## Prerequisites

To run locally you will need:

- Powershell 5.x
- [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au): `Install-Module chocolatey-au` or `choco install chocolatey-au`

## Update Packages Manually:

### Single package

To update a single package:

- `cd` into package subfolder under either `automatic/` or `manual/`
- `.\update.ps1` or edit the `*.nuspec` and `tools\chocolatey*install.ps1`
- `choco pack` to build NuGet package (only for `manual/`)
- `choco install PACKAGE --source .` to install package locally for testing (optional)
- `choco push PACKAGE.VERSION.nupkg --source https://push.chocolatey.org --key CHOCOLATEY_API_KEY` to push package to Chocolatey


### All packages

To update all automatic updateable packages run (not pushing):

- `cd automatic`
- `.\update_all.ps1`

To update and push packages to Chocolatey:

- `cd automatic`
- `$env:API_KEY="CHOCOLATEY_API_KEY"; .\update_all.ps1 -ChocoPush`
