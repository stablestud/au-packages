param (
    [string]$VersionOverride
)

Import-Module chocolatey-au

function Get-ArchiveStringsFromUrl {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Url
    )

    try {
        $content = (Invoke-WebRequest -Uri $Url -UseBasicParsing).Content
    }
    catch {
        throw "Failed to download content from '$Url'. $($_.Exception.Message)"
    }

    # Match quoted or unquoted strings containing 'xmlblueprint-archive'
    $matches = [regex]::Matches(
        $content,
        '(?i)(?:"([^"]*xmlblueprint-archive-[^"]*)"|''([^'']*xmlblueprint-archive-[^'']*)''|(\S*xmlblueprint-archive-\S*))'
    )

    $results = foreach ($match in $matches) {
        $match.Groups[1..3] | Where-Object { $_.Value } | ForEach-Object { $_.Value }
    }

    return $results |
        Sort-Object -Unique
}

function Get-HighestArchiveVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]$ArchiveStrings,

        [Parameter(Mandatory=$false)]
        [string]$OverrideVersion
    )

    $versions = foreach ($item in $ArchiveStrings) {
        if ($item -match 'xmlblueprint-archive-(\d+(?:\.\d+)+)') {
            try {
                [PSCustomObject]@{
                    Source  = $item
                    Version = [version]$matches[1]
                }
            }
            catch {
                # Skip invalid version formats
            }
        }
    }

    if (-not $versions) {
        throw 'No valid archive versions were found.'
    }

    # Return the override version if specified, otherwise return the highest version
    if ($OverrideVersion) { 
        return $versions | Where-Object { $_.Version -eq [version]$OverrideVersion }
    } else {
        return $versions | Sort-Object Version -Descending | Select-Object -First 1
    }
}

function global:au_GetLatest {
    $url = "https://filedn.eu/l6hrQdIONMfS36XFW6FwzhS" # do not add a / slash to the URL end
    $archives = Get-ArchiveStringsFromUrl -Url $url
    if ($VersionOverride) {
        $latest = Get-HighestArchiveVersion -ArchiveStrings $archives -OverrideVersion $VersionOverride
    } else {
        $latest = Get-HighestArchiveVersion -ArchiveStrings $archives
    }

    if (-not ($latest -is [array])) {
        # Single binary available for version, assuming 64bit
        return @{ Version = $latest.Version; Url32 = "$url/$($latest.Source)" }
    } else {
        # Multiple binaries available for versions, assuming 64bit and 32bit versions available
        $version32 = $latest | Where-Object { $_.Source -match '32bit\.exe$' }
        $version64 = $latest | Where-Object { $_.Source -notmatch '32bit\.exe$' }
        return @{ Version = $version64.Version; Url32 = "$url/$($version32.Source)"; Url64 = "$url/$($version64.Source)" }
    }

}

function global:au_SearchReplace {
    return @{
        "tools\chocolateyinstall.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.Url32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.Url64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

if ($VersionOverride) {
    Write-Host "Override version to $VersionOverride"
    Update-Package -NoReadme -NoCheckChocoVersion
} else {
    Update-Package -NoReadme
}
