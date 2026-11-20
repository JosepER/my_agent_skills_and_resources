#!/usr/bin/env bash
# Copy the skills in this repo to the user's Claude Code directory (macOS/Linux).
#
# Copies every folder under skills/ to <claude dir>/skills/<skill-name>,
# replacing any installed skill of the same name. Other installed skills are
# left alone. Run it again after pulling to update.
#
# Usage:
#   bash install.sh               # skills only
#   bash install.sh --claude-md   # also copy claude-md/CLAUDE.md to
#                                 # <claude dir>/CLAUDE.md (an existing one is
#                                 # saved as CLAUDE.md.bak first)
#
# The Claude directory defaults to ~/.claude. Set CLAUDE_DIR to use another.

set -euo pipefail

include_claude_md=false
for argument in "$@"; do
    case "$argument" in
        --claude-md) include_claude_md=true ;;
        *)
            echo "Unknown option: $argument" >&2
            echo "Usage: bash install.sh [--claude-md]" >&2
            exit 1
            ;;
    esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
claude_dir="${CLAUDE_DIR:-$HOME/.claude}"
skills_source="$repo_root/skills"
skills_target="$claude_dir/skills"

mkdir -p "$skills_target"

for skill in "$skills_source"/*/; do
    skill_name="$(basename "$skill")"
    target="$skills_target/$skill_name"

    if [ -L "$target" ]; then
        # A symlink (possibly to this repo): remove only the link, never the
        # files it points to.
        rm "$target"
    elif [ -e "$target" ]; then
        rm -rf "$target"
    fi

    cp -R "$skills_source/$skill_name" "$target"
    echo "Installed skill: $skill_name"
done

if [ "$include_claude_md" = true ]; then
    claude_md_target="$claude_dir/CLAUDE.md"

    if [ -e "$claude_md_target" ]; then
        cp "$claude_md_target" "$claude_md_target.bak"
        echo "Backed up existing CLAUDE.md to CLAUDE.md.bak"
    fi

    cp "$repo_root/claude-md/CLAUDE.md" "$claude_md_target"
    echo "Installed CLAUDE.md"
fi

echo "Done. Installed to $claude_dir"
