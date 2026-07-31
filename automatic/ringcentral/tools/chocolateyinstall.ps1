$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'https://app.ringcentral.com/download/RingCentral-x64.msi'
$checksum64 = 'CB852BDB6B20AF64A38733107F4AAF13A46BBD2A3F0EDF2FBFC5C2DFCD10908E'
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
