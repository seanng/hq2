---
name: hq-pm-authoring
description: Shared HQ project-management authoring conventions for parent plans, PRDs, AGENTS.md curation, project scaffolding, and dependency declaration. Use when an agent needs to author or update a parent initiative plan, decompose work into a PRD set, scaffold a new project in the vault, replan mid-execution, or set up dispatchable PRD frontmatter. This is the authoring counterpart to `hq-prd-worker-lifecycle`.
---

# HQ PM Authoring

This skill defines the standard authoring-side conventions for HQ project management. Any agent acting as a planner / PM for the vault uses these conventions to keep parent plans, PRDs, AGENTS.md files, and project scaffolding consistent across the system.

The matched-pair sibling skill `hq-prd-worker-lifecycle` covers the execution side (how a worker updates a PRD as they run it). Use this skill when you are *writing* the artifacts; use that skill when you are *executing* one.

## Scope

Use this skill when you need to:

- Scaffold a new project (any directory that holds an `ops/prds/` folder).
- Author a new parent initiative plan.
- Decompose a plan into a PRD set with explicit dependencies.
- Curate `AGENTS.md` so workers have durable, current context.
- Replan an in-flight initiative (update plan, close or open PRDs).
- Author PRD frontmatter that is safe to dispatch against.

Do not use this skill for:

- Worker-side PRD updates during execution — see `hq-prd-worker-lifecycle`.
- File and folder naming — see `hq-vault-naming`.
- Dispatcher-only concerns: session-start resume scans, front-door routing, workflow-tier classification, personal-conversation handling, post-dispatch crash recovery. Those are properties of the dispatching agent, not of PM authoring.

## Vault Layout

HQ is an Obsidian vault. Per-person content lives under `areas/` (one folder per
business area or domain), with the operating system (`.claude/`, `.agents/`,
`system/`) tracked separately at the vault root. The PM authoring surface lives
inside `areas/`.

Areas have **heterogeneous shapes**: some go area → projects directly, some
introduce intermediate layers (e.g. `services/<svc>/projects/<project>/`), and
some have no projects at all. Project structure is therefore **not encoded in a
fixed path depth**.

```
<vault-root>/
├── system/                       # tracked — shared conventions and templates
│   ├── conventions/
│   └── templates/                #   prd / plan / project templates
├── areas/                        # per-person content
│   └── <area>/                   # a business area or domain
│       ├── <project>/            # project: directly under an area …
│       │   ├── README.md         # Project home note
│       │   ├── AGENTS.md         # Durable worker context (PM-curated)
│       │   ├── ops/
│       │   │   ├── plans/        # Parent initiative plans
│       │   │   └── prds/         # Canonical execution artifacts
│       │   ├── notes/            # Optional
│       │   ├── research/         # Optional
│       │   ├── assets/           # Optional
│       │   ├── repos/            # Git repos (optional)
│       │   ├── designs/          # Optional
│       │   ├── marketing/        # Optional
│       │   ├── finance/          # Optional
│       │   └── admin/            # Optional
│       └── <intermediate>/       # … or nested under an intermediate layer
│           └── <project>/        #   (e.g. services/<svc>/projects/<project>/)
│               └── ops/prds/     #   project root is wherever ops/ lives
└── README.md
```

All file and folder names follow `hq-vault-naming` (lowercase kebab-case, exceptions for `README.md` and `AGENTS.md`).

### What Is a Project

**A project is any directory that contains an `ops/prds/` folder.** That folder —
not a fixed path prefix — is the canonical marker.

- **PRD discovery** uses a recursive marker glob: `areas/**/ops/prds/*.md`.
- **Project root is derived dynamically** from each PRD's location: it is the
  directory that contains the PRD's `ops/` folder (i.e. `<prd-path>/../../`).
  Never assume a fixed depth such as `areas/<area>/<project>/`.
- All path-relative fields (`working_path`, dispatch `--add-dir`) resolve against
  this dynamically-derived project root, so they work at any depth.
- **Scan guardrail**: scope discovery to `areas/` and prune repo/code dirs — drop
  any PRD path that lies **under a repo root** (a directory that contains a `.git`
  folder) — so `**` does not descend into codebases and false-match a stray
  `ops/prds/`. Note: a bare `find ... -name .git -prune` prunes only the `.git`
  directory, not its sibling subtrees, so it does not suffice. Compute repo roots
  first, then exclude:

  ```
  # 1. repo roots = dirs containing a .git
  repos=$(find areas -type d -name .git -prune | sed 's#/\.git$##')
  # 2. candidate PRDs, minus anything under a repo root
  find areas -path '*/ops/prds/*.md' -print | while read -r f; do
    skip=0; for r in $repos; do case "$f" in "$r"/*) skip=1;; esac; done
    [ "$skip" -eq 0 ] && echo "$f"
  done
  ```

## Three-Layer Memory Model

Paths below are relative to the project root (the directory containing `ops/`),
which is derived dynamically per the marker rule above.

1. **Parent plan** (`<project-root>/ops/plans/<initiative>.md`) — Planning memory. Objective, outcome level, scope, phases, linked PRDs, revisions.
2. **AGENTS.md** (`<project-root>/AGENTS.md`) — Worker-facing durable execution context. Domain facts, stack decisions, conventions, constraints. Things specialists need repeatedly.
3. **PRDs** (`<project-root>/ops/prds/<prefix>-NNN-<slug>.md`) — Canonical execution artifacts. Each PRD is the spec AND the task state.

When deciding where context belongs:

- Planning rationale, scope decisions, phase strategy → parent plan.
- Facts workers repeatedly need during execution → AGENTS.md.
- Task-specific spec, constraints, and execution state → PRD.

## Project Scaffolding

Pick the project's location under the appropriate `areas/<area>/...` path (directly
under the area, or under an intermediate layer if the area uses one). Creating the
`ops/prds/` folder is what makes the directory a discoverable project. Always create:

- `<project-root>/README.md`
- `<project-root>/AGENTS.md`
- `<project-root>/ops/plans/`
- `<project-root>/ops/prds/`

Create optional folders only when the first artifact needs them:

- `notes/`, `research/`, `assets/`, `repos/`, `designs/`, `marketing/`, `finance/`, `admin/`

## Parent Plan Authoring

For multi-PRD initiatives, you must create or update a parent plan before creating PRDs.

**Hard rule: no multi-PRD initiatives without a parent plan.**

- If an active plan exists → update it and append revision history.
- If no plan exists → create one at `<project-root>/ops/plans/<initiative>.md`.
- Use the template at `system/templates/plan.md`.
- Use semantic names (e.g., `launch-website.md`, not `plan-001.md`).

**Atomic tasks** (single PRD, no scope ambiguity) may skip the plan — the PRD then omits the `plan` field.

**Parallel design directions**: For any sizable frontend design phase where multiple layouts or aesthetic directions are viable (page designs, landing pages, major UI overhauls, brand identity), propose 2–3 competing direction theses in the plan. Each thesis must be meaningfully different — not minor variations. These directions go into a single design PRD; the design agent orchestrates the parallel exploration internally.

**Completeness pass**: Before finalizing, ask yourself:

- Is this enough for the intended outcome level?
- What essential work is still missing?
- What is intentionally deferred?
- For each category of work, decide: included now, deferred, or unnecessary.

## PRD Authoring

PRDs are the canonical execution artifacts. Each PRD is both the spec and the task state.

### Frontmatter Schema

```yaml
---
id: bk-001
title: Build landing page
status: queue
project: bickleball
plan: launch-website # omit entirely for standalone PRDs
agent: frank
working_path: repos/app # relative to project root
depends_on: [bk-000]
review_mode: human # self | human
priority: 10
created: 2026-04-02
updated: 2026-04-02
---
```

**`plan` field**: For atomic tasks with no parent plan, omit the field entirely. Do not use `plan: null`.

**`working_path` field**: The most specific directory the agent should operate in, relative to the project container root. Examples:

- Code: `repos/app`
- Design: `designs`
- Marketing: `marketing`
- General: `.`

### Status Model

| Status            | Meaning                                   |
| ----------------- | ----------------------------------------- |
| `queue`           | Planned, waiting to start                 |
| `in_progress`     | Active specialist execution               |
| `review`          | Human checkpoint or approval needed       |
| `needs_attention` | Abnormal state, failure, or triage needed |
| `done`            | Complete                                  |
| `cancelled`       | Intentionally abandoned                   |

**blocked** (derived, display-only): A PRD is blocked when `status: queue` and one or more `depends_on` entries are not `done`. Do not put `blocked` in frontmatter.

### PRD Body Sections

Use the template at `system/templates/prd.md`. Key sections:

- Objective, Context, Acceptance Criteria, Implementation Notes, Out of Scope
- Work Log (concise: key decisions + outcomes, appended by worker)
- Handoff / Next Action (what's needed to continue)
- Result (summary, files modified, discoveries — filled by worker)

### PRD Naming

`<prefix>-NNN-<slug>.md` — e.g., `bk-001-landing-page-build.md`

Use sequential numbering per project prefix. Glob `<project-root>/ops/prds/<prefix>-*.md` to find the next number.

### Authoring Rules

- One agent per PRD. One bounded scope per PRD.
- Acceptance criteria must be specific and testable.
- Dependencies must be explicit in `depends_on`.
- `working_path` must be set to the most specific directory for the work, and it must be a directory that exists or can be scaffolded on demand (`designs/`, `marketing/`, etc.). Do not author PRDs that dispatch into missing repo CWDs — author a prior PRD for the scaffolding and use `depends_on`.
- Review mode must be explicit on every PRD.
- Create the **complete PRD set** for an initiative before dispatching any. All PRDs must exist so the operator can see the full shape of work and dependencies are trackable.

## AGENTS.md Curation

`AGENTS.md` holds worker-facing durable execution context for a project. Include only facts that specialists need repeatedly:

- Brand / product context
- Audience
- Stack decisions
- Architecture constraints
- Conventions and project-specific rules

Do NOT put planning history or phase strategy in AGENTS.md — that belongs in the parent plan.

Greenfield: create from scratch. Brownfield: curate actively — update entries whose facts have changed, remove entries that are no longer true, and date significant additions (`<!-- added YYYY-MM-DD -->`). Stale context is worse than missing context.

## Dependency Resolution

Within a project:

1. Glob `<project-root>/ops/prds/*.md` (the project's own `ops/prds/` folder).
2. Parse frontmatter for `id`, `status`, `depends_on`.
3. Build `done_ids = { id for PRDs where status == "done" }`.
4. A `queue` PRD is **ready** if `depends_on` is empty or all entries are in `done_ids`.
5. Otherwise it is **blocked** — skip during dispatch and describe it as blocked in operator summaries when relevant.

Cross-project dependencies are out of scope for v1.

## Outcome Levels

Assume **launch-ready** unless the operator says otherwise.

- **Prototype**: Enough to prove the idea. May omit deployment, analytics, SEO, production QA.
- **Launch-ready**: Publicly usable and responsibly shipped. Design, implementation, deployment, baseline SEO/analytics, launch QA.
- **Growth-ready**: Launch-ready plus measurement/optimization foundations. Conversion review, experiment hooks, deeper SEO, analytics dashboards.

## Mid-execution Replanning

When a PRD returns `review` or `needs_attention`, the operator wants to change direction, or a missing requirement surfaces:

1. Read the active parent plan.
2. Read relevant PRDs and their Result/Work Log sections.
3. Read the project's `AGENTS.md`.
4. **Update the parent plan first** — append revision history.
5. Then propose new PRDs (following the normal approval flow).

## Hard Rules

- **No multi-PRD initiative without a parent plan.** Atomic single-PRD tasks may skip the plan; the PRD then omits the `plan` field.
- **Scaffold before you build.** Verify project scaffolding exists before authoring plans or PRDs. A directory is only a discoverable project once it has an `ops/prds/` folder; PRDs placed anywhere else are not discoverable.
- **Create all initiative PRDs before dispatching any.** JIT PRD creation is not permitted for multi-PRD initiatives.
- **The vault is the system of record.** Plans live in `<project-root>/ops/plans/`. PRDs live in `<project-root>/ops/prds/`. Discovery is by the marker glob `areas/**/ops/prds/*.md`; anything outside a project's `ops/` tree is not discoverable by dispatch or resume logic.
- **One agent, one scope per PRD.** Split anything broader.
- **`working_path` must point at a directory that exists or can be scaffolded on demand.**
- **Update the parent plan before creating or modifying PRDs during replanning.**
- **AGENTS.md holds durable worker context only.** No planning history, no one-shot task notes.
- **Distinguish included, excluded, and deferred / recommended-next work** in every substantive plan.
- **Assume launch-ready outcome unless told otherwise.**
