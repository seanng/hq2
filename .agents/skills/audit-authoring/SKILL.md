---
name: audit-authoring
description: Draft an AI Opportunity Audit from a completed Discovery engagement's internal source files — assemble the client deliverable defined by the audit template from opportunities.md, the workflow map, and the stakeholder map; enforce plain-name discipline, the two-register split, forbidden-vocabulary checks, and DRAFT/export conventions. Use during Step 5 of an AI Practice Discovery engagement (Conrad), after synthesis and scoring are done. Triggers on "draft the audit", "write the audit", "audit deliverable", "export the audit PDF".
---

# Audit Authoring

Assemble the client-facing AI Opportunity Audit from a Discovery engagement's internal source files. This skill is the drafting counterpart to `workflow-synthesis-scoring` (which produces the scored `opportunities.md` this draws from).

**The template is the spec.** `areas/agentic-maison/ai/2-discovery/audit-template.md` is the single source of truth for section structure, the scoring table, the pre-ship checklist, and the voice rules. Stamp from it; do not restate or re-order its sections here. Doctrine: `ai/AGENTS.md` ("The audit", two registers, naming, forbidden vocabulary) wins on conflict.

## When to use

Step 5 of Discovery, after `workflow-synthesis-scoring` has produced a ranked, scored `opportunities.md` and the current-state map and stakeholder map exist. Do not start drafting until scoring is complete (it is a single end-of-engagement pass, not a living document).

## Inputs (all internal — none ship; only the exported PDF does)

- `discovery/synthesis/opportunities.md` — ranked, scored set → the Executive Summary ranking table, the Proposed Pilot rationale, the Further Opportunities reasoning
- `discovery/workflows/*.md` — current-state notes → Current-State Workflow
- `discovery/stakeholder-map.md` — authority + adoption → the stakeholder roster in Risks, Constraints, and Stakeholders (prose, not a table)
- `discovery/GLOSSARY.md` — terminology only, to keep names/terms accurate; **never quoted or shipped**
- the engagement `AGENTS.md` / `README.md` — client name, owner, sessions, dates, discovery tier

## Assembly procedure

Stamp a copy of the template, then fill each section from its source. Draft the **body first, the summary last** — the Executive Summary is a précis of what the body concludes, so writing it first invites drift.

The structure is **pilot first, then the rest**: the #1 opportunity is treated in full under **Proposed Pilot**, every other opportunity once under **Further Opportunities**, and no opportunity is described twice in prose. Each opportunity's score rationale is shown inline as three Impact / Feasibility / Time axis bullets (under Proposed Pilot for the pilot, under Further Opportunities for the rest) — there is no separate scoring appendix.

Fill the sections in the template's exact order and by their exact names (do not renumber; the template owns the section list and headings):

1. **Current-State Workflow** ← `workflows/*.md`. Walk the chain; name bottlenecks; link each to the opportunity it feeds, **by name** (the plain names in the ranking table).
2. **Proposed Pilot** ← the #1 opportunity: the one-line first-move justification, then #1's score rationale as the three axis bullets, then the pilot build fields. No "what comes after" list here — the expansions live under Further Opportunities.
3. **Further Opportunities** ← `opportunities.md` per-opportunity reasoning for the remaining opportunities, in ranked order, each as a prose lead plus the three axis bullets, framed as the sequenced expansion path. Any opportunities beyond the 3-5 cap are named in one line each in the closing tail.
4. **Risks, Constraints, and Stakeholders** ← `stakeholder-map.md` + the adoption sub-factor behind each Feasibility score (so the roster and the ranking-table scores cohere). Stakeholders are prose, never a table.
5. **Conclusion** ← the closing summary: the finding, the recommended first move, the sequenced larger prize, and the through-line design principle.
6. **Executive Summary** (now) ← the headline finding, the ranked table under an "AI Opportunities Ranking" subheading (# · Opportunity · Description · Impact · Feasibility · Time), the three-axes explainer below the table, and the recommended first pilot named.
7. **Introduction** ← how many sessions, with whom, over what period; that the client's own material was a reference but the substance comes from the conversations; then the **coverage statement** (who was interviewed and, when partial, what is not yet covered). The coverage statement is required whenever coverage is partial.

## Plain-name discipline

Name each opportunity in the owner's plain words from the catalog menu (`materials/agent-catalog.md`); never invent a product name. The opportunity-type taxonomy and value-type labels stay backstage in `opportunities.md` and never appear in the audit body. See `ai/AGENTS.md` "Naming opportunities".

## Register and forbidden-vocabulary checks

Professional consultancy register throughout the body: plain, direct, evidence-led, warm without being casual — no marketing fluff, superlatives, or conversational throat-clearing. The firm is "we"; address the client directly ("you" / "your" is acceptable) or by name, whichever reads most naturally; contractions are fine. No fashion-house lexicon (maison, atelier, commissioned). Before any client-visible draft, grep the body against the forbidden-vocabulary list in `ai/AGENTS.md` ("Forbidden vocabulary in client-facing copy" — the canonical list; never copy it here) and confirm zero hits. Never reveal the question bank is AI-generated or that follow-up surfacing is AI-assisted.

## No fabrication

Never invent a client number, quote, workflow detail, or stakeholder position. `[needs from client: ...]` placeholders may be used in the internal working source **while drafting**, but must be resolved or removed before any render — they never appear in a rendered PDF, not even the operator-review DRAFT. Surface open data needs to the operator out of band (PRD Handoff), never in the deliverable. The interviews are complete, so the report reads as finished work, not a request for more: no "what we would still want from you" or "specifics we would confirm" homework section.

## DRAFT discipline and export

Work the full **pre-ship checklist in the template** before shipping. DRAFT while drafting (frontmatter `status: DRAFT`, banner at top, draft marker in the footer); on FINAL (post operator review) flip the status and delete the banner and the draft footer marker. Render with `areas/agentic-maison/ai/2-discovery/render-audit.py <source.md>`, which writes the prose-shaped PDF to the engagement's `discovery/shared/` folder as `ai-opportunity-audit-<slug>.pdf` — the filename is **stable across DRAFT and FINAL**; draft state lives only in the footer marker and frontmatter, never the filename. Not `.docx`; not a separate `deliverables/` folder.

`render-audit.py` produces a **branded cover page** from frontmatter and stamps a running **header** (the wordmark + report/client line) and a **page-number footer** onto every content page. The cover fields, the tier-aware report label, and the brand palette are canonical in the renderer and documented once in the template's PART A — do not restate them here. The markdown body carries no title block, no H1, and no horizontal rules between sections; the cover and the running furniture are the renderer's job. Headings are the template's unnumbered noun phrases — the report opens with **Introduction** and the summary section is **Executive Summary** — and cross-references use section names, not numbers.

## Outputs

- `discovery/sources/audit.md` — the audit source markdown (internal working file).
- `discovery/shared/ai-opportunity-audit-<slug>.pdf` — the exported client deliverable (the only artifact that ships).

The audit ships on its own — the pilot proposal is a **separate** artifact (`sources/pilot-proposal.md`), never bundled into or referenced from the diagnostic audit; its disclosure is conditional (Part 2 of the presentation).

Closing the engagement: a **two-part live presentation** (Part 1 audit readout · conditional Part 2 pilot proposal) and, after it, a case-study draft (see `ai/AGENTS.md` and `2-discovery/README.md`).
