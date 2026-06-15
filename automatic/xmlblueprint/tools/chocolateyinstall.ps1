$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://filedn.eu/l6hrQdIONMfS36XFW6FwzhS/xmlblueprint-22.2026.06.11.exe'
$checksum   = '3e99e1a5fd0bb389e3144e51afad9389ff7b9d163e053a9c6fd3fba7cba6aa5d'
$installerArgs = $env:ChocolateyPackageParameters
$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = $toolsDir
    fileType      = 'EXE'
    url           = $url
    softwareName  = 'XMLBlueprint*'
    checksum      = $checksum
    checksumType  = 'sha256'
    silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- $installerArgs"
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
