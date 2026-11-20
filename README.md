# My agent skills and resources

Claude Code skills and instructions I use for OECD work.

## Contents

| Path | What it is |
| --- | --- |
| `skills/oecd-chart-design-aesthetics/` | Visual design and wording rules for OECD-style charts (palettes, typography, gridlines, titles, sources and notes). |
| `skills/oecd-writing-style/` | Drafting and proofreading English text in OECD house style (OECD Style Guide, 4th edition, 2025). |
| `skills/python-style/` | My Python coding style (Python 3.12, type hints, Google-style docstrings, Polars, scripts vs. notebooks). |
| `install.ps1`, `install.sh` | Scripts that copy the skills (and optionally the global CLAUDE.md) into `~/.claude/` on Windows and macOS/Linux. |
| `claude-md/CLAUDE.md` | My global Claude Code instructions (language-agnostic coding guidelines, with a pointer to `python-style`). Kept in a subfolder so it doesn't act as this repo's own project instructions. |

Each skill follows the standard layout: a `SKILL.md` with `name` and
`description` frontmatter, plus optional `references/` files that the skill
loads when needed.

## Installing

Skills go in `~/.claude/skills/<skill-name>/`. The install scripts copy every
skill in this repo there, replacing installed skills of the same name and
leaving any others alone. Run them again after pulling to update.

On Windows:

```powershell
.\install.ps1                    # skills only
.\install.ps1 -IncludeClaudeMd   # also install the global CLAUDE.md
```

On macOS or Linux:

```bash
bash install.sh               # skills only
bash install.sh --claude-md   # also install the global CLAUDE.md
```

With the CLAUDE.md option, an existing `~/.claude/CLAUDE.md` is saved as
`CLAUDE.md.bak` before being replaced. Install it together with the skills:
it tells Claude to load `python-style`.

### Linking instead of copying

Linking the folders keeps the installed skills in sync with this repo without
re-running the script. On Windows, a directory junction works without admin
rights:

```powershell
$repo = "<path to your clone of this repo>"
foreach ($skill in "oecd-chart-design-aesthetics", "oecd-writing-style", "python-style") {
    cmd /c mklink /J "$env:USERPROFILE\.claude\skills\$skill" "$repo\skills\$skill"
}
```

For the global instructions, copy the file into place:

```powershell
Copy-Item "$repo\claude-md\CLAUDE.md" "$env:USERPROFILE\.claude\CLAUDE.md"
```

## Adding a skill

Add a folder under `skills/` containing a `SKILL.md`. If a skill arrives as a
packaged `.skill` file, unzip it into `skills/` rather than committing the
`.skill` file itself.
