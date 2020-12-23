# for task
# https://taskfile.org
using namespace System.Management.Automation

Register-ArgumentCompleter -Native -CommandName task -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)

    $completions = @()

    $reg = "\* (.+): \ *(.*)"
    $listOutput = $(task -l)
    $listOutput | Select-String $reg -AllMatches | ForEach-Object { 
        $completions += [CompletionResult]::new(
            $_.Matches.Groups[1].Value,
            $_.Matches.Groups[1].Value,
            [CompletionResultType]::Command,
            $_.Matches.Groups[2].Value
        )
    }

    $completions += @(
        [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'colored output (default true)')
        [CompletionResult]::new('--color', 'color', [CompletionResultType]::ParameterName, 'colored output (default true)')
        [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'sets directory of execution')
        [CompletionResult]::new('--dir', 'dir', [CompletionResultType]::ParameterName, 'sets directory of execution')
        [CompletionResult]::new('--dry', 'dry', [CompletionResultType]::ParameterName, 'compiles and prints tasks in the order that they would be run, without executing them')
        [CompletionResult]::new('--dry', 'dry', [CompletionResultType]::ParameterName, 'compiles and prints tasks in the order that they would be run, without executing them')
        [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'forces execution even when the task is up-to-date')
        [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'forces execution even when the task is up-to-date')
        [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'shows Task usage')
        [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'shows Task usage')
        [CompletionResult]::new('-i', 'i', [CompletionResultType]::ParameterName, 'creates a new Taskfile.yml in the current folder')
        [CompletionResult]::new('--init', 'init', [CompletionResultType]::ParameterName, 'creates a new Taskfile.yml in the current folder')
        [CompletionResult]::new('-l', 'l', [CompletionResultType]::ParameterName, 'lists tasks with description of current Taskfile')
        [CompletionResult]::new('--list', 'list', [CompletionResultType]::ParameterName, 'lists tasks with description of current Taskfile')
        [CompletionResult]::new( '-o', 'o', [CompletionResultType]::ParameterName, 'sets output style: [interleaved|group|prefixed]')
        [CompletionResult]::new( '--output', 'output', [CompletionResultType]::ParameterName, 'sets output style: [interleaved|group|prefixed]')
        [CompletionResult]::new( '-p', 'p', [CompletionResultType]::ParameterName, 'executes tasks provided on command line in parallel')
        [CompletionResult]::new( '--parallel', 'parallel', [CompletionResultType]::ParameterName, 'executes tasks provided on command line in parallel')
        [CompletionResult]::new( '-s', 's', [CompletionResultType]::ParameterName, 'disables echoing')
        [CompletionResult]::new( '--silent', 'silent', [CompletionResultType]::ParameterName, 'disables echoing')
        [CompletionResult]::new( '--status', 'status', [CompletionResultType]::ParameterName, 'exits with non-zero exit code if any of the given tasks is not up-to-date')
        [CompletionResult]::new( '--summary', 'summary', [CompletionResultType]::ParameterName, 'show summary about a task')
        [CompletionResult]::new( '-t', 't', [CompletionResultType]::ParameterName, 'choose which Taskfile to run. Defaults to "Taskfile.yml"')
        [CompletionResult]::new( '--taskfile', 'taskfile', [CompletionResultType]::ParameterName, 'choose which Taskfile to run. Defaults to "Taskfile.yml"')
        [CompletionResult]::new( '-v', 'v', [CompletionResultType]::ParameterName, 'enables verbose mode')
        [CompletionResult]::new( '--verbose', 'verbose', [CompletionResultType]::ParameterName, 'enables verbose mode')
        [CompletionResult]::new( '--version', 'version', [CompletionResultType]::ParameterName, 'show Task version')
        [CompletionResult]::new( '-w', 'w', [CompletionResultType]::ParameterName, 'enables watch of the given task')
        [CompletionResult]::new( '--watch', 'watch', [CompletionResultType]::ParameterName, 'enables watch of the given task')
    )

    $curReg = "task[\.exe]? (.*?)$"
    $startsWith = $wordToComplete |
    Select-String $curReg -AllMatches |
    ForEach-Object { $_.Matches.Groups[1].Value }

    $completions.Where{ $_.ListItemText -like "$startsWith*" }
}