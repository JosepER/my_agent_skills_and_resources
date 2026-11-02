# My agent skills and resources

Claude Code skills and instructions I use for OECD work.

## Contents

| Path | What it is |
| --- | --- |
| `skills/oecd-chart-design-aesthetics/` | Visual design and wording rules for OECD-style charts (palettes, typography, gridlines, titles, sources and notes). |
| `skills/oecd-writing-style/` | Drafting and proofreading English text in OECD house style (OECD Style Guide, 4th edition, 2025). |
| `claude-md/CLAUDE.md` | My global Claude Code instructions (Python coding guidelines). Kept in a subfolder so it doesn't act as this repo's own project instructions. |

Each skill follows the standard layout: a `SKILL.md` with `name` and
`description` frontmatter, plus optional `references/` files that the skill
loads when needed.

## Installing

Skills go in `~/.claude/skills/<skill-name>/`. Linking the folders (rather
than copying them) keeps the installed skills in sync with this repo.

On Windows, a directory junction works without admin rights:

```powershell
$repo = "<path to your clone of this repo>"
foreach ($skill in "oecd-chart-design-aesthetics", "oecd-writing-style") {
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
