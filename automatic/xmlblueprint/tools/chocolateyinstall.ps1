# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

# 1. See the _TODO.md that is generated top level and read through that
# 2. Follow the documentation below to learn how to create a package for the package type you are creating.
# 3. In Chocolatey scripts, ALWAYS use absolute paths - $toolsDir gets you to the package's tools directory.
$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Internal packages (organizations) or software that has redistribution rights (community repo)
# - Use `Install-ChocolateyInstallPackage` instead of `Install-ChocolateyPackage`
#   and put the binaries directly into the tools folder (we call it embedding)
#$fileLocation = Join-Path $toolsDir 'NAME_OF_EMBEDDED_INSTALLER_FILE'
# If embedding binaries increase total nupkg size to over 1GB, use share location or download from urls
#$fileLocation = '\\SHARE_LOCATION\to\INSTALLER_FILE'
# Community Repo: Use official urls for non-redist binaries or redist where total package size is over 200MB
# Internal/Organization: Download from internal location (internet sources are unreliable)
$url32        = 'https://www.xmlblueprint.com/update/download-64bit.php' # download url, HTTPS preferred
$checksum32   = '50631c91e192c7c7d44a80166702158d39f8e8b4c46f51e5563dca48549c8e95'
$url64        = 'https://www.xmlblueprint.com/update/download-64bit.php' # download url, HTTPS preferred
$checksum64   = '50631c91e192c7c7d44a80166702158d39f8e8b4c46f51e5563dca48549c8e95'

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    unzipLocation = $toolsDir
    fileType      = 'EXE' #only one of these: exe, msi, msu
    url           = $url32
    url64         = $url64
#file         = $fileLocation

    softwareName  = 'XMLBlueprint*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

# Checksums are required for packages which will be hosted on the Chocolatey Community Repository.
# To determine checksums, you can get that from the original site if provided.
# You can also use checksum.exe (choco install checksum) and use it
# e.g. checksum -t sha256 -f path\to\file
    checksum        = $checksum32
    checksum64      = $checksum64
    checksumType    = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    checksumType64  = 'sha256' #default is md5, can also be sha1, sha256 or sha512

    silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
    validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage
