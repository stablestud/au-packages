$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://filedn.eu/l6hrQdIONMfS36XFW6FwzhS/xmlblueprint-22.2026.08.17.exe'
$checksum   = 'c6648d1d56f1375828b56d0b55d4d9ddba57800eb9f27fcdab6103ebf8755a2e'
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
