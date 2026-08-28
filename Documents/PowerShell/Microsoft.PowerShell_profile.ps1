# For reference
# $env:PATH="$env:PATH;C:\opt\vim-9.1.0\vim91\"
# $env:PATH="$env:PATH;C:\opt\MinGit-2.49.0\cmd\"
#
######################################################################
# Settings
######################################################################
Set-PSReadLineOption -BellStyle None

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
# Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

######################################################################
# Functions
######################################################################
function who {
    query user
}
function uptime {
    Get-CimInstance -ClassName win32_operatingsystem | Select-Object lastbootuptime
}
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
    if ($ParentPath.Length -gt 0 -and !(Test-Path -PathType Container $ParentPath)) {
        # Make sure parent path exists.
        New-Item -ItemType Directory -Path $(Split-Path -Parent $OutputPath) -Force > $null
    }

    Write-Output "Downloading $(Split-Path -Leaf $OutputPath)"

    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $Url -OutFile $OutputPath

    Write-Output "Saved to $OutputPath"
}
function sha256sum {
    param (
        [string]$Path
    )
    foreach ($i in Get-FileHash -A SHA256 $Path) {
        Write-Output "$($i.Hash.ToLower())  $($i.Path | Resolve-Path -Relative)"
    }
}
function md5sum {
    param (
        [string]$Path
    )
    foreach ($i in Get-FileHash -A MD5 $Path) {
        Write-Output "$($i.Hash.ToLower())  $($i.Path | Resolve-Path -Relative)"
    }
}

function find {
    param (
        [string]$Path = $PWD,
        [string]$Pattern
    )
    foreach ($i in Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue -Include $Pattern) {
        $path = Join-Path $i.Directory $i.Name
        Write-Output "$($path | Resolve-Path -Relative)"
    }
}
