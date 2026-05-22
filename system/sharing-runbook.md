---
title: hq2 Sharing + Friend-Onboarding Runbook
tags:
  - runbook
  - onboarding
  - sharing
audience: operator
---

# hq2 Sharing + Friend-Onboarding Runbook

This is a runbook the **operator** follows by hand to:

1. share the `areas/agentic-maison` body of work with a content-only collaborator
   (the "friend") via Obsidian Sync, and
2. onboard that friend onto the hq2 framework itself.

It is a followable checklist, not automation. The Obsidian Sync account work and
the invite are manual GUI steps the operator performs; this document just makes
each step unambiguous and explains the rationale.

> [!info] Why two mechanisms?
> hq2 separates the **operating system** (agents, skills, conventions) from
> **content** (PRDs, notes, planning). The OS is distributed by **git** (clone +
> setup). Content under `areas/` is **git-ignored** and shared per-folder by
> **Obsidian Sync**. The two never overlap. Full rationale lives in the
> architecture decision note kept with the hq-productize project.

---

## Mental model (read this first)

- The operator's **primary Obsidian vault is `hq2`** (the whole framework
  directory).
- `areas/agentic-maison` is **its own nested Obsidian Sync vault** inside hq2. It
  gets its own `.obsidian` folder purely so it can be the unit Obsidian Sync
  shares. The friend connects to *that* nested vault, not to `hq2`.
- The friend is **content-only**. They never touch codebases. Repos stay on the
  operator's machine and on GitHub, and are excluded from Sync.
- `areas/` is git-ignored in hq2, so none of this content is ever in the hq2 git
  repo. Git owns the framework and the codebases; Obsidian Sync owns the planning
  content. Anything git owns, Obsidian Sync excludes.

### What the friend gets vs. does not get

| Gets | Does NOT get |
|---|---|
| The hq2 framework (agents, skills, conventions) via git clone + setup | The operator's other `areas/` (e.g. `personal/`, `business-ideas/`) |
| The shared `areas/agentic-maison` content via Obsidian Sync | The operator's `IDENTITY.md` (git-ignored; friend authors their own) |
| Their own per-person `IDENTITY.md`, their own agents/skills layered on top | Any codebase / repo (git-owned, Sync-excluded, never leaves operator's machine + GitHub) |

**Why they don't get the rest:** the operator's personal areas and `IDENTITY.md`
are git-ignored, so they were never in the cloned repo. Codebases are excluded
from the Obsidian Sync vault (Step 2), so they never reach the friend's machine.
The split is structural, not a manual filter you have to remember each time.

> [!note] Obsidian Sync subscription
> Obsidian Sync is a paid Obsidian service. **Each collaborator** (operator and
> friend) needs their own active Obsidian Sync subscription to connect to a synced
> vault. Sort the subscriptions out before the invite step — this runbook does not
> prescribe who pays or how.

---

## Step 1 — Make `areas/agentic-maison` an Obsidian Sync vault

Goal: turn the `agentic-maison` folder into its own Obsidian Sync remote, distinct
from the operator's primary `hq2` vault.

1. **Give the folder its own `.obsidian`.** In Obsidian, use *Open folder as
   vault* and point it at `areas/agentic-maison`. Obsidian creates a `.obsidian`
   config folder there. This nested `.obsidian` exists only so Obsidian Sync has a
   vault to attach to — keep its config minimal.
2. **Enable Sync for this vault.** With `agentic-maison` open as a vault: Settings
   → Sync → turn Sync on.
3. **Create a new remote vault** named e.g. `agentic-maison` and connect this
   local folder to it. Do **not** reuse the operator's main `hq2` remote.

> [!warning] Nested-vault caveat — avoid double-sync
> `agentic-maison` lives *inside* the hq2 directory, which is also a vault on the
> operator's machine. If the operator ever enables Obsidian Sync on the **outer
> `hq2` vault as well**, the same files would be synced twice (once by each vault),
> causing conflicts and churn.
>
> The intended setup: **only the nested `agentic-maison` vault is connected to
> Obsidian Sync.** The outer `hq2` directory is the operator's working vault for
> editing but is **not** itself an Obsidian Sync remote — hq2 is distributed by
> **git**, not Sync. If you do open hq2 as a Sync vault for any reason, add
> `areas/agentic-maison` to its Excluded folders so the nested vault owns those
> files exclusively.

---

## Step 2 — Configure Excluded folders (keep code out of Sync)

In the `agentic-maison` vault: Settings → Sync → **Excluded folders**. Exclude
every code/build path so Obsidian Sync never churns source trees and never fights
with git.

Exclude (relative to the `agentic-maison` vault root):

- `repos/`  *(and every project's `repos/` path — see below)*
- `node_modules/`
- `.next/`
- `.vercel/`
- `dist/`
- `build/`
- `.git/`

**Project `repos/` paths that exist today** (exclude each; re-check whenever a new
project adds code):

- `services/digital/projects/sd-hk-dental-clinics/repos/`

> [!tip] Finding repo paths
> List the code folders to exclude from the framework root:
> `find areas/agentic-maison -type d \( -name repos -o -name node_modules -o -name .git -o -name .next \)`

**Why exclude these:**

- **Git already owns code.** Codebases are versioned in their own git repos.
  Obsidian Sync does not carry `.git`, so syncing a repo would strip its history,
  fight git's working tree, and produce conflicts.
- **Churn and quota.** `node_modules/`, `.next/`, `.vercel/`, `dist/`, `build/`
  are large, regenerated build artifacts. Syncing them wastes Sync quota and
  generates constant noise.
- **Content-only friend.** The friend never works on code. Excluding repos means
  codebases never reach their machine — the privacy/scope boundary is enforced by
  the exclude list, not by trust.

Rule of thumb: **anything git owns, Obsidian Sync excludes.**

---

## Step 3 — Friend's framework onboarding (git side)

This gets the hq2 operating system onto the friend's machine. It is independent of
Obsidian Sync — it installs the agents, skills, and conventions.

1. **Clone the hq2 repo.** Invite the friend to the private hq2 repo on GitHub (or
   your chosen distribution method), then have them clone it to `~/hq2`.
2. **Run `setup.sh`.** From the repo root: `./setup.sh`. It installs prerequisites,
   global tooling, and registers the agents/skills. (setup.sh is owned by its own
   workstream; just run it as documented there. It is idempotent — safe to re-run.)
3. **First Pam session runs the IDENTITY interview.** The friend's first session
   with Pam prompts them to create their own `IDENTITY.md` from
   `IDENTITY.example.md`. This file is **git-ignored and per-person** — the friend
   builds their own operator profile; they never see the operator's `IDENTITY.md`.

After this step the friend has a working hq2 with an **empty `areas/`** (git-ignored,
kept alive by `.gitkeep`). They have the framework but no shared content yet — that
arrives in Step 4.

> [!note] The friend's framework is their own
> The friend can layer their own agents and skills on top (their own Pam
> personality, extra skills). Only the HQ-related agents/skills stay shared via the
> repo. Divergence in personal agents/skills is expected and fine.

---

## Step 4 — Invite the friend to the agentic-maison Sync vault

Now share the content. This is a manual Obsidian Sync invite.

1. In the `agentic-maison` vault: Settings → Sync → **manage / collaborators** →
   invite the friend by their Obsidian account email.
2. Tell the friend to, in their own Obsidian, **connect to the shared
   `agentic-maison` remote vault** and choose where to put it locally. The natural
   place is **`~/hq2/areas/agentic-maison`**, so it sits in the same structure the
   agents expect (PRD discovery scans `areas/**/ops/prds/`).
3. Confirm the friend has an active Obsidian Sync subscription (Step 0 note) — the
   connection will not complete without one.

**What the friend sees:** the full `agentic-maison` planning content — services,
projects, PRDs, notes — minus the excluded code folders from Step 2.

**What the friend does NOT see:**

- The operator's other areas (`personal/`, `business-ideas/`, etc.). Those are
  separate folders that were never added to this Sync vault and are git-ignored, so
  they are neither cloned nor synced.
- Any codebase. Excluded in Step 2; they stay on the operator's machine + GitHub.
- The operator's `IDENTITY.md`. Git-ignored; never in the repo, never in the Sync
  vault.

---

## Step 5 — Verify

Confirm the share works and the boundaries hold. Do these with the friend.

1. **Friend can open agentic-maison.** The friend opens
   `~/hq2/areas/agentic-maison` (or wherever they connected the Sync vault) in
   Obsidian and sees the synced content (services, projects, PRDs, notes).
2. **Edits round-trip.** Operator edits a note (e.g. adds a line to a PRD or a
   scratch note); the friend sees it sync in within a moment. Friend makes an edit;
   operator sees it come back. Sync is bidirectional.
3. **Codebases are absent on the friend's side.** On the friend's machine, confirm
   the excluded paths did not sync:
   - `ls ~/hq2/areas/agentic-maison/services/digital/projects/sd-hk-dental-clinics/`
     should show the project's planning files **but no `repos/` folder**.
   - Spot-check that no `node_modules/`, `.next/`, `dist/`, or `build/` directories
     appear anywhere under the friend's `agentic-maison`.
4. **Friend has no operator-private content.** Confirm the friend's `~/hq2` has no
   `areas/personal/`, no `areas/business-ideas/`, and that their `IDENTITY.md` is
   their own (not the operator's).

If all four checks pass, the share is correctly scoped: framework via git, content
via Obsidian Sync, code and private areas excluded.

---

## Aside: shared history

Obsidian Sync does not carry git history, so PRD/note history is per-person and
shallow — there is no shared git log of the planning content. This is an accepted
trade-off for the content-only friend. *If* you ever need shared, versioned history
on agentic-maison planning content, that folder would instead move to a git remote
(e.g. automated with the Obsidian Git plugin) rather than Obsidian Sync. Out of
scope here.
