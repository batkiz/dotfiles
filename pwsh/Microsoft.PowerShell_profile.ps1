Import-Module posh-git
Import-Module oh-my-posh

# this theme is in ./PoshThemes
Set-Theme ys

Import-Module scoop-completion

Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# fish-like cli completion
# https://github.com/PowerShell/PSReadLine/releases/tag/v2.1.0-beta1
Set-PSReadLineOption -Colors @{ Prediction = 'DarkGray' }
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function ForwardWord

# command history
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 

# PowerShell parameter completion shim for the dotnet CLI 
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# use nvim in wsl
function dos2nix {
    param($dosPath)

    $path = $dosPath.Replace('\', '/')

    if ($path -match '[a-zA-Z]:.*') {
        $drive = $path.split(':')[0].ToLower()
        $filePath = $path.split(':')[1]

        $nixPath = '/mnt/' + $drive + $filePath
    }

    else {
        $nixPath = $path
    }

    $nixPath
}

function vim {
    param (
        $Path = '.'
    )

    if ($Path -eq '.') {
        $Path = '.'
    }
    else {
        $Path = dos2nix -dosPath $Path
    }

    wsl -d debian -e nvim $Path
}

function wsldown {
    wsl --shutdown
}

function which {
    $results = New-Object System.Collections.Generic.List[System.Object];
    foreach ($command in $args) {
        $path = (Get-Command $command).Source
        if ($path) {
            $results.Add($path);
        }
    }
    return $results;
}

function ListDirectory {
    Get-ChildItem $args | Format-Wide Name -AutoSize
}

function nali {
    param (
        $Query = '',
        [Alias('l')]
        $Lang = 'zh'
    )

    if ($Lang.ToLower() -eq 'en' ) {
        $Lang = 'en'
    }
    else {
        $Lang = 'zh-CN'
    }

    $ApiUrl = "http://ip-api.com/json/{0}?lang={1}" -f $Query, $Lang

    $info = (Invoke-WebRequest $ApiUrl).Content | ConvertFrom-Json

    $printInfo = "{0}`t[{1} @ {2}, {3}]" -f $info.query, $info.isp, $info.city, $info.country

    $printInfo
}

# thanks to https://yugasun.com/post/serverless-practice-dict.html
function fy {
    param (
        $Query = ''
    )

    if ($Query -eq '' ) {
        Write-Output 'this is a cli translator, try `fy hello`.'
    }
    else {
        $ApiUrl = "http://service-7kqwzu92-1251556596.gz.apigw.tencentcs.com/test/dictt?q={0}" -f $Query

        $info = (Invoke-WebRequest $ApiUrl).Content | ConvertFrom-Json

        Write-Host $info.body.data
    }
}

function Get-Size {
    param([string]$pth)
    "{0:n2}" -f ((Get-ChildItem -path $pth -recurse | measure-object -property length -sum).sum / 1mb) + " M"
}

# cli trash
Set-Alias tr trash.exe
Set-Alias e explorer.exe
Set-Alias -Name ls -Value ListDirectory
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name l -Value Get-ChildItem