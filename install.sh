#!/usr/bin/env bash
# Copy the skills in this repo to the user's Claude Code directory (macOS/Linux).
#
# Syncs every folder under skills/ to <claude dir>/skills/<skill-name>. Files
# are compared by SHA-256 hash: only new or changed files are copied, and
# files no longer in the repo are removed from the installed skill. Other
# installed skills are left alone. Run it again after pulling to update. At
# the end it lists the files that were updated and the files that were
# identical and left as they were.
#
# Usage:
#   bash install.sh               # skills only
#   bash install.sh --claude-md   # also copy claude-md/CLAUDE.md to
#                                 # <claude dir>/CLAUDE.md if it differs (an
#                                 # existing one is saved as CLAUDE.md.bak)
#   bash install.sh --dry-run     # show what would be updated, change nothing
#
# The Claude directory defaults to ~/.claude. Set CLAUDE_DIR to use another.

set -euo pipefail

# Arguments -------------------------------------------------------------------

include_claude_md=false
dry_run=false
for argument in "$@"; do
    case "$argument" in
        --claude-md) include_claude_md=true ;;
        --dry-run) dry_run=true ;;
        *)
            echo "Unknown option: $argument" >&2
            echo "Usage: bash install.sh [--claude-md] [--dry-run]" >&2
            exit 1
            ;;
    esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
claude_dir="${CLAUDE_DIR:-$HOME/.claude}"
skills_source="$repo_root/skills"
skills_target="$claude_dir/skills"

# Results collected while syncing and printed as a summary at the end.
updated_files=()
unchanged_files=()

# Functions -------------------------------------------------------------------

# Print the SHA-256 hash of a file. Linux has sha256sum, macOS has shasum.
file_hash() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | cut -d ' ' -f 1
    else
        shasum -a 256 "$1" | cut -d ' ' -f 1
    fi
}

# Succeed when the target file exists and has the same hash as the source.
same_file() {
    local source_path="$1"
    local target_path="$2"

    [ -f "$target_path" ] || return 1
    [ "$(file_hash "$source_path")" = "$(file_hash "$target_path")" ]
}

# Copy the new or changed files of one skill to its installed folder.
sync_skill_files() {
    local source_dir="$1"
    local target_dir="$2"
    local skill_name="$3"
    local file relative_path target_file label status

    while IFS= read -r -d '' file; do
        relative_path="${file#"$source_dir"/}"
        target_file="$target_dir/$relative_path"
        label="$skill_name/$relative_path"

        if same_file "$file" "$target_file"; then
            unchanged_files+=("$label")
            continue
        fi

        if [ -e "$target_file" ]; then status="changed"; else status="new"; fi
        updated_files+=("$label ($status)")
        if [ "$dry_run" = true ]; then
            continue
        fi

        mkdir -p "$(dirname "$target_file")"
        cp "$file" "$target_file"
    done < <(find "$source_dir" -type f -print0)
}

# Remove installed files of one skill that are no longer in the repo.
remove_stale_skill_files() {
    local source_dir="$1"
    local target_dir="$2"
    local skill_name="$3"
    local installed_file relative_path

    [ -d "$target_dir" ] || return 0

    while IFS= read -r -d '' installed_file; do
        relative_path="${installed_file#"$target_dir"/}"
        if [ -f "$source_dir/$relative_path" ]; then
            continue
        fi

        updated_files+=("$skill_name/$relative_path (removed)")
        if [ "$dry_run" = false ]; then
            rm "$installed_file"
        fi
    done < <(find "$target_dir" -type f -print0)
}

# Print a heading with a count, then one indented line per file.
print_file_list() {
    local heading="$1"
    shift

    echo "$heading ($#):"
    if [ "$#" -eq 0 ]; then
        echo "  (none)"
    fi
    for file in "$@"; do
        echo "  $file"
    done
}

# Skills ----------------------------------------------------------------------

if [ "$dry_run" = false ]; then
    mkdir -p "$skills_target"
fi

for skill in "$skills_source"/*/; do
    skill_name="$(basename "$skill")"
    source_dir="$skills_source/$skill_name"
    target="$skills_target/$skill_name"

    # A symlink (possibly to this repo) is replaced by a copy. Remove only the
    # link, never the files it points to. It is handled before hashing because
    # its files may be the repo files themselves.
    if [ -L "$target" ]; then
        updated_files+=("$skill_name/ (link replaced by a copy)")
        if [ "$dry_run" = false ]; then
            rm "$target"
            cp -R "$source_dir" "$target"
        fi
        continue
    fi

    sync_skill_files "$source_dir" "$target" "$skill_name"
    remove_stale_skill_files "$source_dir" "$target" "$skill_name"
done

# CLAUDE.md -------------------------------------------------------------------

if [ "$include_claude_md" = true ]; then
    claude_md_source="$repo_root/claude-md/CLAUDE.md"
    claude_md_target="$claude_dir/CLAUDE.md"

    if same_file "$claude_md_source" "$claude_md_target"; then
        unchanged_files+=("CLAUDE.md")
    elif [ -e "$claude_md_target" ]; then
        updated_files+=("CLAUDE.md (changed, old one saved as CLAUDE.md.bak)")
        if [ "$dry_run" = false ]; then
            cp "$claude_md_target" "$claude_md_target.bak"
            cp "$claude_md_source" "$claude_md_target"
        fi
    else
        updated_files+=("CLAUDE.md (new)")
        if [ "$dry_run" = false ]; then
            mkdir -p "$claude_dir"
            cp "$claude_md_source" "$claude_md_target"
        fi
    fi
fi

# Summary ---------------------------------------------------------------------

# The ${array[@]+...} form expands an empty array safely under `set -u` on
# the bash 3.2 that ships with macOS.
if [ "$dry_run" = true ]; then
    echo "Dry run: no files were changed in $claude_dir"
    print_file_list "Would be updated" ${updated_files[@]+"${updated_files[@]}"}
else
    echo "Installed to $claude_dir"
    print_file_list "Updated" ${updated_files[@]+"${updated_files[@]}"}
fi
print_file_list "Not updated (identical)" ${unchanged_files[@]+"${unchanged_files[@]}"}
