$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32        = 'https://filedn.eu/l6hrQdIONMfS36XFW6FwzhS/xmlblueprint-archive-18.2021.12.15.exe'
$checksum32   = '38d21b01f9939382ed9a127fabc2ac1c01a2d939bdd8b5c8dafd17f904b88a65'
$url64        = ''
$checksum64   = '38d21b01f9939382ed9a127fabc2ac1c01a2d939bdd8b5c8dafd17f904b88a65'
$installerArgs = $env:ChocolateyPackageParameters

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = $toolsDir
    fileType      = 'EXE'
    url           = $url32
    softwareName  = 'XMLBlueprint*'
    checksum      = $checksum32
    checksumType  = 'sha256'
    silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- $installerArgs"
    validExitCodes = @(0)
}

if ($url64) {
    $packageArgs['url64bit'] = $url64
    $packageArgs['checksum64'] = $checksum64
} elseif (-not $checksum32) {
    $packageArgs['checksum'] = $checksum64
}

Install-ChocolateyPackage @packageArgs
