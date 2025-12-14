$Options = [ordered]@{
    Timeout = 100
    Threads = 15
    Push    = $true

    # Save text report in the local file report.txt
    Report = @{
        Type = 'text'
        Path = "$PSScriptRoot\report.txt"
    }

    # Then save this report as a gist using your api key and gist id
    Gist = @{
        ApiKey = $Env:github_api_key
        Id     = $Env:github_gist_id
        Path   = "$PSScriptRoot\report.txt"
    }

    # Persist pushed packages to your repository
    Git = @{
        User = $Env:github_user
        Password = $Env:github_api_key
    }

    <#
    # Then save run info which can be loaded with Import-CliXML and inspected
    RunInfo = @{
        Path = "$PSScriptRoot\update_info.xml"
    }

    # Finally, send an email to the user if any error occurs and attach previously created run info
    Mail = if ($Env:mail_user) {
            @{
               To          = $Env:mail_user
               Server      = 'smtp.gmail.com'
               UserName    = $Env:mail_user
               Password    = $Env:mail_pass
               Port        = 587
               EnableSsl   = $true
               Attachment  = "$PSScriptRoot\$update_info.xml"
               UserMessage = 'Save attachment and load it for detailed inspection: <code>$info = Import-CliXCML update_info.xml</code>'
            }
    } else {}
    #>
}

Update-AUPackages -Options $Options
