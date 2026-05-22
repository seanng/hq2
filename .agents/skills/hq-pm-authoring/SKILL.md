---
name: hq-pm-authoring
description: Shared HQ project-management authoring conventions for parent plans, PRDs, AGENTS.md curation, project scaffolding, and dependency declaration. Use when an agent needs to author or update a parent initiative plan, decompose work into a PRD set, scaffold a new project under the vault, replan mid-execution, or set up dispatchable PRD frontmatter. This is the authoring counterpart to `hq-prd-worker-lifecycle`.
---

# HQ PM Authoring

This skill defines the standard authoring-side conventions for HQ project management. Any agent acting as a planner / PM for the vault uses these conventions to keep parent plans, PRDs, AGENTS.md files, and project scaffolding consistent across the system.

The matched-pair sibling skill `hq-prd-worker-lifecycle` covers the execution side (how a worker updates a PRD as they run it). Use this skill when you are *writing* the artifacts; use that skill when you are *executing* one.

## Scope

Use this skill when you need to:

- Scaffold a new project under `1-projects/`.
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

HQ is an Obsidian vault at `~/hq` following the PARA framework. The PM authoring surface lives inside `1-projects/`.

```
~/hq/
├── 0-inbox/
├── 1-projects/<project>/
│   ├── README.md              # Project home note
│   ├── AGENTS.md              # Durable worker context (PM-curated)
│   ├── ops/
│   │   ├── plans/             # Parent initiative plans
│   │   └── prds/              # Canonical execution artifacts
│   ├── notes/                 # Optional
│   ├── research/              # Optional
│   ├── assets/                # Optional
│   ├── repos/                 # Git repos (optional)
│   ├── designs/               # Optional
│   ├── marketing/             # Optional
│   ├── finance/               # Optional
│   └── admin/                 # Optional
├── 2-areas/
│   └── hq/                    # HQ-internal documents and templates
├── 3-resources/
├── 4-archive/
└── README.md
```

All file and folder names follow `hq-vault-naming` (lowercase kebab-case, exceptions for `README.md` and `AGENTS.md`).

## Three-Layer Memory Model

1. **Parent plan** (`1-projects/<project>/ops/plans/<initiative>.md`) — Planning memory. Objective, outcome level, scope, phases, linked PRDs, revisions.
2. **AGENTS.md** (`1-projects/<project>/AGENTS.md`) — Worker-facing durable execution context. Domain facts, stack decisions, conventions, constraints. Things specialists need repeatedly.
3. **PRDs** (`1-projects/<project>/ops/prds/<prefix>-NNN-<slug>.md`) — Canonical execution artifacts. Each PRD is the spec AND the task state.

When deciding where context belongs:

- Planning rationale, scope decisions, phase strategy → parent plan.
- Facts workers repeatedly need during execution → AGENTS.md.
- Task-specific spec, constraints, and execution state → PRD.

## Project Scaffolding

When creating a new project, always create:

- `1-projects/<project>/README.md`
- `1-projects/<project>/AGENTS.md`
- `1-projects/<project>/ops/plans/`
- `1-projects/<project>/ops/prds/`

Create optional folders only when the first artifact needs them:

- `notes/`, `research/`, `assets/`, `repos/`, `designs/`, `marketing/`, `finance/`, `admin/`

## Parent Plan Authoring

For multi-PRD initiatives, you must create or update a parent plan before creating PRDs.

**Hard rule: no multi-PRD initiatives without a parent plan.**

- If an active plan exists → update it and append revision history.
- If no plan exists → create one at `1-projects/<project>/ops/plans/<initiative>.md`.
- Use the template at `~/hq/2-areas/hq/templates/plan.md`.
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

Use the template at `~/hq/2-areas/hq/templates/prd.md`. Key sections:

- Objective, Context, Acceptance Criteria, Implementation Notes, Out of Scope
- Work Log (concise: key decisions + outcomes, appended by worker)
- Handoff / Next Action (what's needed to continue)
- Result (summary, files modified, discoveries — filled by worker)

### PRD Naming

`<prefix>-NNN-<slug>.md` — e.g., `bk-001-landing-page-build.md`

Use sequential numbering per project prefix. Glob `1-projects/<project>/ops/prds/<prefix>-*.md` to find the next number.

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

1. Glob `1-projects/<project>/ops/prds/*.md`.
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
- **Scaffold before you build.** Verify project scaffolding exists before authoring plans or PRDs. PRDs at the project root or other wrong locations are not discoverable.
- **Create all initiative PRDs before dispatching any.** JIT PRD creation is not permitted for multi-PRD initiatives.
- **The vault is the system of record.** Plans live in `ops/plans/`. PRDs live in `ops/prds/`. Anything outside the canonical paths is not discoverable by dispatch or resume logic.
- **One agent, one scope per PRD.** Split anything broader.
- **`working_path` must point at a directory that exists or can be scaffolded on demand.**
- **Update the parent plan before creating or modifying PRDs during replanning.**
- **AGENTS.md holds durable worker context only.** No planning history, no one-shot task notes.
- **Distinguish included, excluded, and deferred / recommended-next work** in every substantive plan.
- **Assume launch-ready outcome unless told otherwise.**
