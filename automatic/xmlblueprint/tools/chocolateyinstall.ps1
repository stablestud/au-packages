$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32        = 'https://www.xmlblueprint.com/update/download-64bit.php'
$checksum32   = '50631c91e192c7c7d44a80166702158d39f8e8b4c46f51e5563dca48549c8e95'
$url64        = 'https://www.xmlblueprint.com/update/download-64bit.php'
$checksum64   = '50631c91e192c7c7d44a80166702158d39f8e8b4c46f51e5563dca48549c8e95'
$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = $toolsDir
    fileType      = 'EXE'
    url           = $url32
    url64         = $url64

    softwareName  = 'XMLBlueprint*'

    checksum        = $checksum32
    checksum64      = $checksum64
    checksumType    = 'sha256'
    checksumType64  = 'sha256'

    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
    validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
