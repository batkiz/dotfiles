Import-Module posh-git
Import-Module oh-my-posh

# this theme is in ./PoshThemes
Set-Theme ys

# use scoop-completion in github.com/batkiz/backit bucket
$scoopdir = $(Get-Item $(Get-Command scoop).Path).Directory.Parent.FullName
Import-Module "$scoopdir\modules\scoop-completion"

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
function vim {
    param($fileName = '.')
    wsl -e nvim $filename.Replace('\', '/').Replace('C:', '/mnt/c')
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

# cli trash
Set-Alias tr trash.exe
Set-Alias e explorer.exe
