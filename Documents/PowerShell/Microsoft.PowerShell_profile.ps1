# For reference
# $env:PATH="$env:PATH;C:\opt\vim-9.1.0\vim91\"
# $env:PATH="$env:PATH;C:\opt\MinGit-2.49.0\cmd\"
#
######################################################################
# Settings
######################################################################
Set-PSReadLineOption -BellStyle None
# Enforce defaults
[Console]::WindowWidth=84
[Console]::WindowHeight=26
[Console]::BufferHeight=9999

######################################################################
# Aliases
######################################################################
Set-Alias -Name c -Value clear
Set-Alias -Name npp -Value "C:/Program Files/Notepad++/notepad++.exe"

######################################################################
# Keybinds
######################################################################
# Set ctrl-d to behave as 'exit' just like in Bash
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('exit')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
# Tab to show a menu instead of inline cycling
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

######################################################################
# Functions
######################################################################
function explorer {
    param (
        $Path = $PWD
    )
    explorer.exe $Path
}
# Remove any pre-existing system alias so we can override it
Remove-Item Alias:wget -Force 2> $null
function wget {
    param (
        [string]$Url,
        [string]$OutputPath = $(Split-Path -Leaf $Url)
    )
    if (Test-Path -PathType Container $OutputPath) {
        # Output path is a directory so make the full path
        $OutputPath = Join-Path "$OutputPath" "$(Split-Path -Leaf $Url)"
    }
    $ParentPath = Split-Path -Parent $OutputPath
    if (!(Test-Path -PathType Container $ParentPath) -and $ParentPath.Length -gt 0) {
        # Make sure parent path exists.
        New-Item -ItemType Directory -Path $(Split-Path -Parent $OutputPath) -Force > $null
    }

    Write-Host "Downloading $(Split-Path -Leaf $OutputPath)"

    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $Url -OutFile $OutputPath

    Write-Host "Saved to $OutputPath"
}
function find {
    param (
        [string]$Path = $PWD,
        [string]$Pattern
    )
    return Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue -Include $Pattern
}
