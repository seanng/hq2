# hq2

hq2 is the HQ operating system: a git-tracked, shareable framework of Claude Code
agents, skills, and conventions for running your work with an agentic team. It is
the control plane — the agents and the rules they follow — kept cleanly separate
from your personal content.

> **Status:** working framework. The agents, skills, conventions, and the
> PRD-tracking dashboard (`tasks.base`) are live. On a fresh clone `areas/` is
> empty — your own projects, PRDs, and notes populate it as you work.

## The core split: tracked OS, ignored content

The single most important idea in hq2 is the boundary between the operating
system and per-person content:

- **Git-tracked = the operating system / template.** Shared, versioned, and
  distributed via the onboarding/setup flow. This is `.claude/`, `.agents/`,
  `system/`, `tasks.base`, `README.md`, and `IDENTITY.example.md`.
- **Git-ignored = per-person content.** This is everything under `areas/` and
  your real `IDENTITY.md`. It never enters git, so your private work and profile
  stay on your machine.

The `.gitignore` is drawn precisely so the two never overlap.

## Layout

```
hq2/
  .claude/              # tracked — Claude Code agents + skill symlinks + settings
  .agents/              # tracked — skill content (the real files behind .claude/skills)
  system/               # tracked — shared conventions and templates only (no personal data)
    conventions/        #   cross-cutting conventions the agents follow
    templates/          #   prd / plan / project templates
  tasks.base            # tracked — Obsidian Base; PRD dashboard over areas/**/ops/prds
  README.md             # tracked — this file
  IDENTITY.example.md   # tracked — fill-in-the-blanks operator-profile template
  IDENTITY.md           # GITIGNORED — your real profile (created on first run)
  .gitignore            # ignores areas/ and IDENTITY.md
  areas/                # GITIGNORED — all per-person content
    .gitkeep            #   keeps the empty dir alive after clone
```

`IDENTITY.md` is intentionally absent from this repo. Only the template
(`IDENTITY.example.md`) ships.

## Getting started

1. **Clone** this repo, then run `./setup.sh` from the repo root. The installer
   (macOS) checks prerequisites, installs the CLIs / Python / Node packages the
   skills depend on, bootstraps the Tavily key and Google Workspace OAuth,
   registers the Claude Code plugin, and seeds an `IDENTITY.md` for you. It is
   idempotent and derives the vault root from its own location, so it works
   wherever you cloned it. Use `./setup.sh --dry-run` first to preview every
   step without changing anything.
2. **Create your profile.** `setup.sh` seeds `IDENTITY.md` from
   `IDENTITY.example.md` if it is missing, but leaves it for you to fill in —
   either edit it by hand or start a first session with Pam, who will interview
   you and populate it. Your `IDENTITY.md` is git-ignored and stays local.
3. **Work happens under `areas/`.** Your projects, PRDs, notes, and codebases
   live there. None of it is tracked by this repo.

## What's inside

- **Agents** (`.claude/agents/`) — a team of specialists (planning, backend,
  frontend, design, marketing, research, and more) you dispatch against PRDs.
- **Skills** (`.agents/skills/`, surfaced via `.claude/skills/`) — reusable
  capabilities the agents draw on, including HQ-authored and vendored skills.
- **Conventions & templates** (`system/`) — the shared rules and document
  templates the agents follow.

## Notes

- A fresh clone contains **no** personal content and **no** personal data —
  `areas/` is empty and `IDENTITY.md` is absent. You get the framework only; your
  work and profile stay local and git-ignored.
- PRD discovery is structure-agnostic: a project is any directory containing an
  `ops/prds/` folder, found via `areas/**/ops/prds/*.md` at any depth. `tasks.base`
  surfaces them as a dashboard.
