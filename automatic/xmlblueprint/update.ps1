Import-Module chocolatey-au

function Get-VersionFromUrl {
    param (
        [string]$Url
    )

    # Extract filename from the Location URL
    $filename = [System.IO.Path]::GetFileName($Url)

    # Check if the filename matches the expected pattern for version
    if (-not ($filename -match '^xmlblueprint-(\d+\.\d+\.\d+\.\d+)\.exe$')) {
        throw "Version format not found in filename: $filename"
    }

    # Extract and return the version from the matched pattern
    return $matches[1]
}

function Get-RedirectUrl {
    param (
        [string]$Url
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    $response = Invoke-WebRequest -Uri $Url -Method Head -UseBasicParsing
    return $response.BaseResponse.ResponseUri.AbsoluteUri
}

function global:au_GetLatest {
    $url = "https://www.xmlblueprint.com/update/download-64bit.php"
    $download = Get-RedirectUrl -Url $url
    $version = Get-VersionFromUrl -Url $download

    return @{ Version = $version; Url = $download }
}

function global:au_SearchReplace {
    return @{
        "tools\chocolateyinstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.Url)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

Update-Package -NoReadme
