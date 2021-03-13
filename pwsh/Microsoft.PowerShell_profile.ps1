Invoke-Expression (&starship init powershell)

function Test-Command([String]$command) {
    return [bool](Get-Command -Name $command `
            -CommandType Application -ErrorAction SilentlyContinue)
}

# CLI COMPLETION

# tab completion
if (Test-Command -command "scoop") {
    Import-Module scoop-completion
}
if (Test-Command -command "cargo") {
    Import-Module posh-cargo
}
if (Test-Command -command "yarn") {
    Import-Module yarn-completion
}
if (Test-Command -command "git") {
    Import-Module posh-git
}

# PowerShell parameter completion shim for the dotnet CLI
if (Test-Command -command "dotnet") {
    Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
        param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

# winget tab completion
if (Test-Command -command "winget") {
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

# several cli completions
if (Test-Command -command "deno") {
    (& deno completions powershell) | Out-String | Invoke-Expression
}
if (Test-Command -command "rustup") {
    (& rustup completions powershell) | Out-String | Invoke-Expression
}
if (Test-Command -command "pdm") {
    (& pdm completion powershell) | Out-String | Invoke-Expression
}
if (Test-Command -command "golangci-lint") {
    (& golangci-lint completion powershell) | Out-String | Invoke-Expression
}
if (Test-Command -command "gh") {
    . $PROFILE\..\Completions\gh.ps1
}
if (Test-Command -command "task") {
    . $PROFILE\..\Completions\task.ps1
}
if (Test-Command -command "volta") {
    . $PROFILE\..\Completions\volta.ps1
}


# zsh like (?) cli completion
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# fish-like cli completion
# need a beta PSReadLine, check
# https://github.com/PowerShell/PSReadLine/releases
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -Colors @{ InlinePrediction = 'DarkGray' }
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function ForwardWord

# command history
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd 



# Internal functions
function Add-ItemToPath([String]$part) {
    $spliter = if ((Test-Path Variable:\IsWindows) -and !$IsWindows) { ':' } else { ';' }
    $env:PATH = "$part$spliter$env:PATH"
}
function Test-PathExist([String]$part) {
    return ("$env:PATH".ToLower() -like "*$part*".ToLower())
}
function Get-NormalizedPath([String]$in) {
    return (Resolve-Path $in -ErrorAction SilentlyContinue)
}
function Get-AllEnv { Get-ChildItem env: }

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


# *nix like which, to get the path of a command
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

# bash like ls, sadly no colors now
function ListDirectory {
    Get-ChildItem $args | Format-Wide Name -AutoSize
}

Set-Alias -Name ls -Value ListDirectory
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name l -Value Get-ChildItem

function sha256sum {
    param (
        $Path
    )
    (Get-FileHash -Algorithm SHA256 -Path $Path).hash.ToLower()
}

# to get the location info of a domain / an IP
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

# cli translator
# thanks to https://github.com/wo52616111/capslock-plus/ for API
function fy {
    if ($args.Length -eq 0 ) {
        Write-Output 'this is a cli translator, try `fy hello world`.'
    }
    else {
        $query = ""
        for ($i = 0; $i -lt $args.Count; $i++) {
            $query += " "
            $query += $args[$i]
        }

        $ApiUrl = "http://fanyi.youdao.com/openapi.do?keyfrom=CapsLock&key=12763084&type=data&doctype=json&version=1.1&q={0}" -f $query

        $info = (Invoke-WebRequest $ApiUrl).Content | ConvertFrom-Json

        Write-Host "@" $query  "[" $info.basic.phonetic "]"
        Write-Host "翻译：`t" $info.translation
        Write-Host "词典："
        for ($i = 0; $i -lt $info.basic.explains.Count; $i++) {
            Write-Host "`t" $info.basic.explains[$i]
        }
        Write-Host "网络："
        for ($i = 0; $i -lt $info.web.Count; $i++) {
            Write-Host "`t" $info.web[$i].key ": " -NoNewline
            for ($j = 0; $j -lt $info.web[$i].value.Count; $j++) {
                Write-Host $info.web[$i].value[$j] "; " -NoNewline
            }
            Write-Host ""
        }
    }
}

# get the size of a dir / a file, in human-readable format
function Get-Size {
    param([string]$pth)
    "{0:n2}" -f ((Get-ChildItem -path $pth -recurse | measure-object -property length -sum).sum / 1mb) + " M"
}

# *nix like time
function time {
    $Command = "$args"

    $time = Measure-Command { Invoke-Expression $Command 2>&1 | out-default }

    $info = "{0:d2}:{1:d2}:{2:d2}.{3}" -f $time.Hours, $time.Minutes, $time.Seconds, $time.Milliseconds

    Write-Output $info
}

# cli proxy!
function socks {
    $Command = "$args"

    Set-CliProxy
    Invoke-Expression $Command 2>&1 | out-default
    Clear-CliProxy
}

function Set-CliProxy {
    $proxy = 'http://127.0.0.1:43333'

    $env:HTTP_PROXY = $proxy
    $env:HTTPS_PROXY = $proxy
}

# set cli proxy by default
Set-CliProxy

function Clear-CliProxy {
    Remove-Item env:HTTP_PROXY
    Remove-Item env:HTTPS_PROXY
}

# cli trash
Set-Alias tr trash.exe
# i often forget how to spell explorer.exe 
Set-Alias e explorer.exe

