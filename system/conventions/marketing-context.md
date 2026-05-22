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
1-projects/<project>/marketing/product-marketing-context.md
```

One marketing-context doc per **marketing surface**. A "surface" is a thing with its own audience, problem set, value proposition, and voice. Verticals and standalone websites are surfaces; underlying services usually aren't.

- `seangentic-web` (the personal-brand site) is a surface — its own audiences, its own positioning.
- `sd-hk-dental-clinics` (a vertical campaign) is a surface — its own audience (HK dental clinic owners), its own value prop.
- "digital service line" is **not** a surface — it manifests through one or more vertical projects, each of which is the surface.

If a project has no marketing surface (e.g. internal tooling, infrastructure), it does not get a `marketing/` folder.

## Brand voice lives at the area level

```
2-areas/<area>/PLAYBOOK.md  # Brand Voice section
```

Brand voice is the **single canonical home** for any cross-project voice that applies across multiple project-level surfaces under the same business area. Projects that roll up to an area reference the area PLAYBOOK rather than duplicating voice content.

If a project is fully self-contained (no parent area), brand voice may live inline in its `marketing/product-marketing-context.md`.

## Roll-up declaration

A project declares it rolls up to an area by adding a single line to its `AGENTS.md`:

```
Roll-up: 2-areas/<area>/
```

- The field is **optional**. Absence means no roll-up.
- Path is vault-relative, terminated with `/`. Always points to an area directory (which contains `PLAYBOOK.md`).
- A project may roll up to at most one area.
- This field is used by marketing agents (Maya, Sam) to locate area-level brand voice. Other agents may read it too, but it is defined by this convention.

## Read order for marketing agents (Maya, Sam)

Before producing strategy or copy, Maya and Sam read context in this exact order:

1. Read the project's `AGENTS.md` (already standard convention for any worker).
2. Look for a `Roll-up:` line in `AGENTS.md`. If present, note the area path; if absent, skip step 4.
3. Read `1-projects/<project>/marketing/product-marketing-context.md` for positioning, audience, problems, differentiation, proof, objections.
4. If `Roll-up:` was set, read the **Brand Voice** section of `<area>/PLAYBOOK.md` for tone, vocabulary, do/don't dimensions.
5. If the positioning doc (step 3) is missing and the task requires it, set the PRD `status: blocked` and surface what's missing in the Work Log. Do not invent positioning.

If the project's `marketing-context.md` itself contains a Brand Voice section (legacy or self-contained project), use that. If both the project doc and the area PLAYBOOK have voice content, the area PLAYBOOK wins for any project with a `Roll-up:` declaration — the project doc's voice content should be removed or replaced with a one-line reference.

## Create-on-demand

Do **not** pre-scaffold `marketing/` folders. Create a project's `marketing/product-marketing-context.md` the first time Maya or Sam is dispatched to a project that needs one. Per-client docs (e.g. for individual clients within a vertical) follow the same rule: create when the agent is first dispatched to write copy or strategy for that client, not preemptively.

## Compatibility with the upstream skill

The upstream Coreyhaines `product-marketing-context` skill governs the **CREATE** flow: when Sean (or Maya/Sam) runs the skill, it produces a new `product-marketing-context.md`. Maya and Sam each carry a path override that redirects the skill's default `.agents/product-marketing-context.md` location to the project-relative path defined above. The upstream skill needs no modification.

This convention doc governs the **READ** flow that runs every time Maya/Sam are dispatched. The two flows are complementary: CREATE writes the doc; READ uses it.

## Examples

### Example 1: self-contained project (no Roll-up)

`hq-productize` is internal meta-tooling. If it ever had a marketing surface (it doesn't, currently), the layout would be:

```
1-projects/hq-productize/
├── AGENTS.md                              # no Roll-up line
└── marketing/
    └── product-marketing-context.md       # positioning AND voice inline
```

Maya/Sam read order: project `AGENTS.md` → project `marketing-context.md` (which carries voice inline). No area PLAYBOOK lookup.

### Example 2: project rolls up to a business area

`sd-hk-dental-clinics` is the HK dental vertical campaign under the Agentic Maison business. The layout:

```
1-projects/sd-hk-dental-clinics/
├── AGENTS.md                              # contains: Roll-up: 2-areas/agentic-maison/
└── marketing/
    └── product-marketing-context.md       # positioning only — no voice section

2-areas/agentic-maison/
└── AGENTS.md                              # Vocabulary section is canonical for voice/tone
```

Maya/Sam read order:
1. Read `1-projects/sd-hk-dental-clinics/AGENTS.md` → find `Roll-up: 2-areas/agentic-maison/`.
2. Read `1-projects/sd-hk-dental-clinics/marketing/product-marketing-context.md` for dental-specific positioning.
3. Read `2-areas/agentic-maison/AGENTS.md` Vocabulary section for tone and vocabulary.
4. Compose strategy or copy using positioning from the project doc and voice from the area AGENTS.md.

The same pattern applies to other agentic-maison-roll-up projects: each has its own positioning doc; all share the agentic-maison area's brand voice.

## Reference

- Upstream skill source: Coreyhaines marketingskills repo (`product-marketing-context` skill)
- Vault naming: see `2-areas/hq/conventions/` (sibling docs) and the `hq-vault-naming` skill
