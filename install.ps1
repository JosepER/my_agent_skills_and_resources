<#
.SYNOPSIS
    Copy the skills in this repo to the user's Claude Code directory (Windows).

.DESCRIPTION
    Copies every folder under skills/ to <ClaudeDir>\skills\<skill-name>,
    replacing any installed skill of the same name. Other installed skills are
    left alone. Run it again after pulling to update.

.PARAMETER ClaudeDir
    The Claude Code directory. Defaults to .claude in your user profile.

.PARAMETER IncludeClaudeMd
    Also copy claude-md\CLAUDE.md to <ClaudeDir>\CLAUDE.md. An existing
    CLAUDE.md is saved as CLAUDE.md.bak first.

.EXAMPLE
    .\install.ps1

.EXAMPLE
    .\install.ps1 -IncludeClaudeMd
#>
[CmdletBinding()]
param(
    [string]$ClaudeDir = (Join-Path $env:USERPROFILE ".claude"),
    [switch]$IncludeClaudeMd
)

$ErrorActionPreference = "Stop"

$skillsSource = Join-Path $PSScriptRoot "skills"
$skillsTarget = Join-Path $ClaudeDir "skills"

New-Item -ItemType Directory -Force $skillsTarget | Out-Null

foreach ($skill in Get-ChildItem $skillsSource -Directory) {
    $target = Join-Path $skillsTarget $skill.Name

    if (Test-Path $target) {
        $isLink = (Get-Item $target -Force).Attributes -band [IO.FileAttributes]::ReparsePoint
        if ($isLink) {
            # A junction or symlink (possibly to this repo): remove only the
            # link, never the files it points to.
            [IO.Directory]::Delete($target, $false)
        }
        else {
            Remove-Item $target -Recurse -Force
        }
    }

    Copy-Item $skill.FullName $target -Recurse
    Write-Host "Installed skill: $($skill.Name)"
}

if ($IncludeClaudeMd) {
    $claudeMdSource = Join-Path $PSScriptRoot "claude-md\CLAUDE.md"
    $claudeMdTarget = Join-Path $ClaudeDir "CLAUDE.md"

    if (Test-Path $claudeMdTarget) {
        Copy-Item $claudeMdTarget "$claudeMdTarget.bak" -Force
        Write-Host "Backed up existing CLAUDE.md to CLAUDE.md.bak"
    }

    Copy-Item $claudeMdSource $claudeMdTarget -Force
    Write-Host "Installed CLAUDE.md"
}

Write-Host "Done. Installed to $ClaudeDir"
