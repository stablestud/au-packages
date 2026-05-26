$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://filedn.eu/l6hrQdIONMfS36XFW6FwzhS/xmlblueprint-22.2026.05.25.exe'
$checksum   = 'e1966f56ea664f8dfcfd196cfd850c4fa3051b1911370de25164bd02acb0b461'
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
