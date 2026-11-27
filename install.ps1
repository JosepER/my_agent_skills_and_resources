<#
.SYNOPSIS
    Copy the skills in this repo to the user's Claude Code directory (Windows).

.DESCRIPTION
    Syncs every folder under skills/ to <ClaudeDir>\skills\<skill-name>.
    Files are compared by SHA-256 hash: only new or changed files are copied,
    and files no longer in the repo are removed from the installed skill.
    Other installed skills are left alone. Run it again after pulling to
    update. At the end it lists the files that were updated and the files that
    were identical and left as they were.

.PARAMETER ClaudeDir
    The Claude Code directory. Defaults to .claude in your user profile.

.PARAMETER IncludeClaudeMd
    Also copy claude-md\CLAUDE.md to <ClaudeDir>\CLAUDE.md if it differs. An
    existing CLAUDE.md is saved as CLAUDE.md.bak first.

.PARAMETER DryRun
    Show what would be updated without changing any files.

.EXAMPLE
    .\install.ps1

.EXAMPLE
    .\install.ps1 -IncludeClaudeMd -DryRun
#>
# PositionalBinding off so a stray argument such as "--dry-run" fails instead
# of being taken as -ClaudeDir.
[CmdletBinding(PositionalBinding = $false)]
param(
    [string]$ClaudeDir = (Join-Path $env:USERPROFILE ".claude"),
    [switch]$IncludeClaudeMd,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# Results collected while syncing and printed as a summary at the end.
$updatedFiles = [System.Collections.Generic.List[string]]::new()
$unchangedFiles = [System.Collections.Generic.List[string]]::new()

# Functions -------------------------------------------------------------------

function Test-SameFile {
    <#
    .SYNOPSIS
        Return $true when the target file exists and has the same SHA-256 hash
        as the source file.
    #>
    [OutputType([bool])]
    param([string]$SourcePath, [string]$TargetPath)

    if (-not (Test-Path $TargetPath -PathType Leaf)) {
        return $false
    }
    $sourceHash = (Get-FileHash $SourcePath -Algorithm SHA256).Hash
    $targetHash = (Get-FileHash $TargetPath -Algorithm SHA256).Hash
    return $sourceHash -eq $targetHash
}

function Get-RelativePath {
    <#
    .SYNOPSIS
        Return the path of a file relative to a root folder.
    #>
    [OutputType([string])]
    param([string]$RootPath, [string]$FilePath)

    return $FilePath.Substring($RootPath.TrimEnd("\").Length + 1)
}

function Sync-SkillFiles {
    <#
    .SYNOPSIS
        Copy the new or changed files of one skill to its installed folder.
    #>
    param([string]$SourceDir, [string]$TargetDir, [string]$SkillName)

    foreach ($file in Get-ChildItem $SourceDir -File -Recurse -Force) {
        $relativePath = Get-RelativePath $SourceDir $file.FullName
        $targetFile = Join-Path $TargetDir $relativePath
        $label = Join-Path $SkillName $relativePath

        if (Test-SameFile $file.FullName $targetFile) {
            $unchangedFiles.Add($label)
            continue
        }

        $status = if (Test-Path $targetFile) { "changed" } else { "new" }
        $updatedFiles.Add("$label ($status)")
        if ($DryRun) {
            continue
        }

        New-Item -ItemType Directory -Force (Split-Path $targetFile) | Out-Null
        Copy-Item $file.FullName $targetFile -Force
    }
}

function Remove-StaleSkillFiles {
    <#
    .SYNOPSIS
        Remove installed files of one skill that are no longer in the repo.
    #>
    param([string]$SourceDir, [string]$TargetDir, [string]$SkillName)

    if (-not (Test-Path $TargetDir)) {
        return
    }

    # Resolve the full path so the relative paths below line up with the
    # FullName of the installed files.
    $resolvedTargetDir = (Get-Item $TargetDir -Force).FullName
    foreach ($installedFile in Get-ChildItem $resolvedTargetDir -File -Recurse -Force) {
        $relativePath = Get-RelativePath $resolvedTargetDir $installedFile.FullName
        if (Test-Path (Join-Path $SourceDir $relativePath) -PathType Leaf) {
            continue
        }

        $updatedFiles.Add("$(Join-Path $SkillName $relativePath) (removed)")
        if (-not $DryRun) {
            Remove-Item $installedFile.FullName -Force
        }
    }
}

function Write-FileList {
    <#
    .SYNOPSIS
        Print a heading with a count, then one indented line per file.
    #>
    param([string]$Heading, [string[]]$Files)

    Write-Host "$Heading ($($Files.Count)):"
    if ($Files.Count -eq 0) {
        Write-Host "  (none)"
    }
    foreach ($file in $Files) {
        Write-Host "  $file"
    }
}

# Skills ----------------------------------------------------------------------

$skillsSource = Join-Path $PSScriptRoot "skills"
$skillsTarget = Join-Path $ClaudeDir "skills"

if (-not $DryRun) {
    New-Item -ItemType Directory -Force $skillsTarget | Out-Null
}

foreach ($skill in Get-ChildItem $skillsSource -Directory) {
    $target = Join-Path $skillsTarget $skill.Name

    # A junction or symlink (possibly to this repo) is replaced by a copy.
    # Remove only the link, never the files it points to. It is handled
    # before hashing because its files may be the repo files themselves.
    $isLink = (Test-Path $target) -and
        ((Get-Item $target -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)
    if ($isLink) {
        $updatedFiles.Add("$($skill.Name)\ (link replaced by a copy)")
        if (-not $DryRun) {
            [IO.Directory]::Delete($target, $false)
            Copy-Item $skill.FullName $target -Recurse
        }
        continue
    }

    Sync-SkillFiles -SourceDir $skill.FullName -TargetDir $target -SkillName $skill.Name
    Remove-StaleSkillFiles -SourceDir $skill.FullName -TargetDir $target -SkillName $skill.Name
}

# CLAUDE.md -------------------------------------------------------------------

if ($IncludeClaudeMd) {
    $claudeMdSource = Join-Path $PSScriptRoot "claude-md\CLAUDE.md"
    $claudeMdTarget = Join-Path $ClaudeDir "CLAUDE.md"

    if (Test-SameFile $claudeMdSource $claudeMdTarget) {
        $unchangedFiles.Add("CLAUDE.md")
    }
    elseif (Test-Path $claudeMdTarget) {
        $updatedFiles.Add("CLAUDE.md (changed, old one saved as CLAUDE.md.bak)")
        if (-not $DryRun) {
            Copy-Item $claudeMdTarget "$claudeMdTarget.bak" -Force
            Copy-Item $claudeMdSource $claudeMdTarget -Force
        }
    }
    else {
        $updatedFiles.Add("CLAUDE.md (new)")
        if (-not $DryRun) {
            New-Item -ItemType Directory -Force $ClaudeDir | Out-Null
            Copy-Item $claudeMdSource $claudeMdTarget -Force
        }
    }
}

# Summary ---------------------------------------------------------------------

if ($DryRun) {
    Write-Host "Dry run: no files were changed in $ClaudeDir"
    Write-FileList -Heading "Would be updated" -Files $updatedFiles
}
else {
    Write-Host "Installed to $ClaudeDir"
    Write-FileList -Heading "Updated" -Files $updatedFiles
}
Write-FileList -Heading "Not updated (identical)" -Files $unchangedFiles
