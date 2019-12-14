Import-Module posh-git
Import-Module oh-my-posh
Import-Module scoop-completion
Set-Theme ys

# PowerShell parameter completion shim for the dotnet CLI 
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
   param($commandName, $wordToComplete, $cursorPosition)
   dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
   }
}

function vim {
   param($fileName = '.')
   wsl -e nvim $filename.Replace('\','/').Replace('C:','/mnt/c')
}

function ip {
   wsl -e curl ip.gs
}

Set-Alias tr trash.exe
Set-Alias e explorer.exe