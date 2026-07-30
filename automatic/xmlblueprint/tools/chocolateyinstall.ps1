$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://filedn.eu/l6hrQdIONMfS36XFW6FwzhS/xmlblueprint-22.2026.07.30.exe'
$checksum   = '8b2f126fd45b1a8934a303a50782cab8aca354b149ff9356ed1282f4739654e3'
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
