---
title: Marketing-context convention
date: 2026-04-30
tags:
  - convention
  - marketing
  - agents
status: living
---

# Marketing-context convention

Canonical rules for where marketing-context documents live, how brand voice is sourced, and how marketing agents (Maya, Sam) read context before producing strategy or copy. This document governs the **READ** flow only — the upstream Coreyhaines [`product-marketing-context`](https://github.com/coreyhaines/marketingskills) skill (frontloaded in Maya and Sam) governs the **CREATE** flow.

## Where marketing-context files live

```
<project-root>/marketing/product-marketing-context.md
```

The project root is the directory that contains the project's `ops/` folder
(see the `hq-pm-authoring` "What Is a Project" rule); the `marketing/` folder sits
beside `ops/`. There is no fixed path depth — projects may sit directly under an
area or under an intermediate layer.

One marketing-context doc per **marketing surface**. A "surface" is a thing with its own audience, problem set, value proposition, and voice. Verticals and standalone websites are surfaces; underlying services usually aren't.

- A personal-brand or standalone marketing site is a surface — its own audiences, its own positioning.
- A vertical campaign (one industry/segment) is a surface — its own audience, its own value prop.
- A horizontal "service line" is **not** a surface — it manifests through one or more vertical projects, each of which is the surface.

If a project has no marketing surface (e.g. internal tooling, infrastructure), it does not get a `marketing/` folder.

## Brand voice lives at the area level

```
areas/<area>/PLAYBOOK.md  # Brand Voice section
```

Brand voice is the **single canonical home** for any cross-project voice that applies across multiple project-level surfaces under the same business area. Projects that roll up to an area reference the area PLAYBOOK rather than duplicating voice content.

If a project is fully self-contained (no parent area), brand voice may live inline in its `marketing/product-marketing-context.md`.

## Roll-up declaration

A project declares it rolls up to an area by adding a single line to its `AGENTS.md`:

```
Roll-up: areas/<area>/
```

- The field is **optional**. Absence means no roll-up.
- Path is vault-relative, terminated with `/`. Always points to an area directory (which contains `PLAYBOOK.md`).
- A project may roll up to at most one area.
- This field is used by marketing agents (Maya, Sam) to locate area-level brand voice. Other agents may read it too, but it is defined by this convention.

## Read order for marketing agents (Maya, Sam)

Before producing strategy or copy, Maya and Sam read context in this exact order:

1. Read the project's `AGENTS.md` (already standard convention for any worker).
2. Look for a `Roll-up:` line in `AGENTS.md`. If present, note the area path; if absent, skip step 4.
3. Read `<project-root>/marketing/product-marketing-context.md` for positioning, audience, problems, differentiation, proof, objections.
4. If `Roll-up:` was set, read the **Brand Voice** section of `<area>/PLAYBOOK.md` for tone, vocabulary, do/don't dimensions.
5. If the positioning doc (step 3) is missing and the task requires it, set the PRD `status: blocked` and surface what's missing in the Work Log. Do not invent positioning.

If the project's `marketing-context.md` itself contains a Brand Voice section (legacy or self-contained project), use that. If both the project doc and the area PLAYBOOK have voice content, the area PLAYBOOK wins for any project with a `Roll-up:` declaration — the project doc's voice content should be removed or replaced with a one-line reference.

## Create-on-demand

Do **not** pre-scaffold `marketing/` folders. Create a project's `marketing/product-marketing-context.md` the first time Maya or Sam is dispatched to a project that needs one. Per-client docs (e.g. for individual clients within a vertical) follow the same rule: create when the agent is first dispatched to write copy or strategy for that client, not preemptively.

## Compatibility with the upstream skill

The upstream Coreyhaines `product-marketing-context` skill governs the **CREATE** flow: when the operator (or Maya/Sam) runs the skill, it produces a new `product-marketing-context.md`. Maya and Sam each carry a path override that redirects the skill's default `.agents/product-marketing-context.md` location to the project-relative path defined above. The upstream skill needs no modification.

This convention doc governs the **READ** flow that runs every time Maya/Sam are dispatched. The two flows are complementary: CREATE writes the doc; READ uses it.

## Examples

### Example 1: self-contained project (no Roll-up)

A standalone marketing site that belongs to no parent business area carries its
positioning and voice inline:

```
areas/<area>/<standalone-site>/
├── AGENTS.md                              # no Roll-up line
├── ops/prds/                              # marks this directory as a project
└── marketing/
    └── product-marketing-context.md       # positioning AND voice inline
```

Maya/Sam read order: project `AGENTS.md` → project `marketing-context.md` (which carries voice inline). No area PLAYBOOK lookup.

### Example 2: project rolls up to a business area

A vertical campaign under a shared business area inherits the area's brand voice
and keeps only its own positioning. Note that projects may sit at varying depths —
here the project is nested under an intermediate `services/<svc>/` layer:

```
areas/<business-area>/services/<svc>/<vertical-campaign>/
├── AGENTS.md                              # contains: Roll-up: areas/<business-area>/
├── ops/prds/                              # marks this directory as a project
└── marketing/
    └── product-marketing-context.md       # positioning only — no voice section

areas/<business-area>/
└── PLAYBOOK.md                            # Brand Voice section is canonical for voice/tone
```

Maya/Sam read order:
1. Read the project's `AGENTS.md` → find `Roll-up: areas/<business-area>/`.
2. Read the project's `marketing/product-marketing-context.md` for the vertical's positioning.
3. Read `areas/<business-area>/PLAYBOOK.md` Brand Voice section for tone and vocabulary.
4. Compose strategy or copy using positioning from the project doc and voice from the area PLAYBOOK.

The same pattern applies to every project that rolls up to the same area: each has its own positioning doc; all share the area's brand voice.

## Reference

- Upstream skill source: Coreyhaines marketingskills repo (`product-marketing-context` skill)
- Vault naming: see `system/conventions/` (sibling docs) and the `hq-vault-naming` skill
