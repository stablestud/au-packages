Import-Module chocolatey-au

function Get-VersionFromUrl {
    param (
        [string]$Url
    )

    # Send a HEAD request and prevent redirects; throw an error if request fails
    $response = Invoke-WebRequest -Uri $Url -Method Head -MaximumRedirection 0 -ErrorAction SilentlyContinue

    # Check if Location header is missing
    if (-not $response.Headers["Location"]) {
        throw "Location header not found in response."
    }

    # Extract the 'Location' header which contains the final URL after a possible redirect
    $location = $response.Headers["Location"]

    # Extract filename from the Location URL
    $filename = [System.IO.Path]::GetFileName($location)

    # Check if the filename matches the expected pattern for version
    if (-not ($filename -match '^xmlblueprint-(\d+\.\d+\.\d+\.\d+)\.exe$')) {
        throw "Version format not found in filename: $filename"
    }

    # Extract and return the version from the matched pattern
    return $matches[1]
}

function global:au_GetLatest {
    $url = "https://www.xmlblueprint.com/update/download-64bit.php"
    $version = Get-VersionFromUrl -Url "https://www.xmlblueprint.com/update/download-64bit.php"

    return @{ Version = $version; Url32 = $url; Url64 = $url }
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

Update-Package -NoReadme
