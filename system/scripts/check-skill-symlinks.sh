#!/usr/bin/env bash
# check-skill-symlinks.sh — verify the skill registry is consistent.
#
# Skills live in .agents/skills/ (the real content) and are surfaced to Claude
# Code via symlinks in .claude/skills/. Claude only discovers skills under
# .claude/skills/ — it does NOT scan .agents/skills/. So every skill that is
# meant to be usable must have a symlink, and every skill referenced in an
# agent's frontmatter must resolve to one of those symlinks.
#
# This script reports three classes of problem:
#   1. Skills in .agents/skills/ with no symlink in .claude/skills/ (auto-fixable)
#   2. Broken symlinks in .claude/skills/ (point at a missing target)
#   3. Skills referenced in .claude/agents/*.md frontmatter that don't resolve
#
# Usage:
#   system/scripts/check-skill-symlinks.sh          # report only; exit 1 if issues
#   system/scripts/check-skill-symlinks.sh --fix    # create missing symlinks (class 1)
#
# The vault root is derived from this script's location (or $CLAUDE_PROJECT_DIR),
# so it works wherever the repo is cloned. Nothing is hardcoded.

set -u
set -o pipefail

FIX=0
[ "${1:-}" = "--fix" ] && FIX=1

# Vault root = two levels up from this script (system/scripts/ -> root), unless
# $CLAUDE_PROJECT_DIR is set and valid.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -d "${CLAUDE_PROJECT_DIR}/.claude" ]; then
  ROOT="$CLAUDE_PROJECT_DIR"
else
  ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fi

SRC="$ROOT/.agents/skills"
DST="$ROOT/.claude/skills"
AGENTS="$ROOT/.claude/agents"

issues=0

# Extract the skills: list from an agent markdown file's YAML frontmatter only.
# Stops at the closing --- so body bullet lists are never mistaken for skills.
agent_skills() {
  awk '
    /^---[ \t]*$/ { fm++; next }
    fm == 1 {
      if ($0 ~ /^skills:/) { p = 1; next }
      if ($0 ~ /^[a-zA-Z][a-zA-Z0-9_-]*:/) { p = 0 }
      if (p && $0 ~ /^[ ]*-/) { gsub(/^[ ]*-[ ]*/, ""); print }
    }
  ' "$1"
}

echo "Skill registry check — root: $ROOT"
echo

# --- Class 1: skills with no symlink ---------------------------------------
# Covers public skills (.agents/skills/*/) and private ones
# (.agents/skills/_private/*/). Both must be symlinked into .claude/skills/ for
# Claude to discover them; private symlinks are simply git-ignored (see
# .gitignore). The _private container dir itself is not a skill — skip it.
echo "1. Skills in .agents/skills/ missing from .claude/skills/:"
missing=0
for d in "$SRC"/*/ "$SRC"/_private/*/; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"
  [ "$name" = "_private" ] && continue
  case "$d" in
    "$SRC"/_private/*) target="../../.agents/skills/_private/$name" ;;
    *)                 target="../../.agents/skills/$name" ;;
  esac
  if [ ! -e "$DST/$name" ] && [ ! -L "$DST/$name" ]; then
    missing=$((missing+1)); issues=$((issues+1))
    if [ "$FIX" = "1" ]; then
      ln -s "$target" "$DST/$name" && echo "   FIXED  $name (symlink -> $target)"
    else
      echo "   MISSING  $name"
    fi
  fi
done
[ "$missing" = "0" ] && echo "   none"
echo

# --- Class 2: broken symlinks ----------------------------------------------
echo "2. Broken symlinks in .claude/skills/:"
broken=0
for l in "$DST"/*; do
  if [ -L "$l" ] && [ ! -e "$l" ]; then
    broken=$((broken+1)); issues=$((issues+1))
    echo "   BROKEN  $(basename "$l") -> $(readlink "$l")"
  fi
done
[ "$broken" = "0" ] && echo "   none"
echo

# --- Class 3: unresolved agent frontmatter references ----------------------
echo "3. Agent frontmatter skills that don't resolve to .claude/skills/:"
unresolved=0
for f in "$AGENTS"/*.md "$AGENTS"/**/*.md; do
  [ -f "$f" ] || continue
  while IFS= read -r skill; do
    [ -z "$skill" ] && continue
    if [ ! -e "$DST/$skill" ]; then
      unresolved=$((unresolved+1)); issues=$((issues+1))
      echo "   UNRESOLVED  $(basename "$f"): $skill"
    fi
  done < <(agent_skills "$f")
done
[ "$unresolved" = "0" ] && echo "   none"
echo

if [ "$issues" = "0" ]; then
  echo "OK — skill registry is consistent."
  exit 0
elif [ "$FIX" = "1" ] && [ "$broken" = "0" ] && [ "$unresolved" = "0" ]; then
  echo "Fixed $missing missing symlink(s). Registry now consistent."
  exit 0
else
  echo "Found $issues issue(s). Run with --fix to create missing symlinks (class 1)."
  echo "Class 3 unresolved references need the underlying skill to exist in .agents/skills/ first."
  exit 1
fi
