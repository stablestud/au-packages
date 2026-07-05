$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://app.ringcentral.com/download/RingCentral-x64.msi'
$checksum64 = '1EBE4B0BBBC4F3591558F63D04634D1A5040A9CAC7E2CB7494262BC3A5E0BCC2'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  softwareName  = 'RingCentral'
  fileType      = 'MSI'
  url64bit      = $url64
  checksum64      = $checksum64
  checksumType64  = $checksumType64
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
