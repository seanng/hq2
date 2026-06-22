---
name: workflow-synthesis-scoring
description: Turn Discovery session material into a workflow synthesis and a ranked, scored set of AI-augmentation opportunities — map current-state workflows, classify each opportunity, score it on calibrated Impact / Feasibility / Time anchors, rank with explicit tie-breaks, and pick the first pilot. Use during Step 4 of an AI Practice Discovery engagement (Conrad), when scoring opportunities, or whenever they must be ranked consistently against the practice rubric. Triggers on "workflow synthesis", "score opportunities", "opportunity ranking", "Impact/Feasibility/Time", or "which pilot first".
---

# Workflow Synthesis & Scoring

Single source of truth for the AI Practice opportunity-scoring rubric. The audit template (`2-discovery/audit-template.md`) and `ai/AGENTS.md` defer here for the calibrated 1-5 anchors, which live in [REFERENCE.md](REFERENCE.md). On conflict, `ai/AGENTS.md` wins. Archetype library: `materials/agent-catalog.md`.

The rubric is the proof the audit is worth its fee: every score carries its reasoning, and every gap is a `[needs from client: ...]`, never fabricated. Defensibility, including showing the rejects, is the deliverable.

## When to use

Step 4 of Discovery, **after all planned sessions are complete** and the `GLOSSARY.md` exists. Synthesis is a single deliberate pass over the full written record, not a living document. Do **not** create or re-rank `opportunities.md` incrementally after each session: re-ranking as sessions land lets the most recent interview bias the order (recency bias). Score once, with fresh eyes, from the complete set of files.

## Inputs

- `discovery/interviews/*` — session notes
- `discovery/GLOSSARY.md` — domain terms (never quoted into the audit)
- `discovery/workflows/*.md` — current-state notes (you may be writing these in Step 1)
- `discovery/stakeholder-map.md` — decision authority + adoption posture
- `materials/agent-catalog.md` — archetypes (A1–A10) + V-series, for classification and the moat test

Score from this written record (interview files + workflow artifacts), not from live impressions of the conversations. The deliberate read of the documented evidence, done once, is what removes recall and recency bias.

## Pre-synthesis completeness gate

Synthesis runs on the *complete* written record — so before scoring, confirm the record is actually complete. Reconcile three lists:

1. **Planned sessions** — every `prep/question-bank-<slug>.md` and every interviewee in `stakeholder-map.md`.
2. **Filed notes** — every file in `discovery/interviews/`.
3. **The session roster** in `interviews/README.md` (planned interviewee → note filed? → disposition).

Every planned or held session must resolve to **either** a filed interview note **or** an explicit disposition (`declined` · `not held` · `merged into <slug>` · `superseded`). A prepped session — a question bank exists — with no note and no disposition is the exact failure this gate catches: **stop and flag it to the operator; do not synthesize around the hole silently.** Recover the source if it exists (recording, session log, operator notes) and file the note, or record the disposition.

Partial coverage by decision is allowed, but never silent: it must be recorded so the audit's coverage statement and the "what this audit does not yet cover" note reflect exactly who was and was not in the room.

## Process

**1. Map current state.** One file per workflow in `discovery/workflows/`: stages, owners, where time and money accumulate, bottlenecks named, and at least one place *not* worth effort. Do **not** consult the catalog yet — classify in Step 4, after the map is honest.

**2. Identify opportunities.** Surface candidates from the map and from what the owner wants leverage on. Get decision-support / executive-leverage candidates on the list *before* ranking (an hours-saved frame buries them). Score every credible candidate backstage. The **3-5 cap is the audit's, not this file's** — surplus folds into "what comes after" or the deprioritized/killed list (keep rejects, one line each).

**3. Score — three axes, 1-5.** First name the **value type** (`time saved · cost reduced · risk avoided · decision speed/quality · revenue`) and the metric; score **Impact on that value type**, never collapsed to hours. Each axis is a **judged roll-up of named sub-factors, never a computed average**:
- Impact ← value created: value type + magnitude, regardless of how it is built — intelligence and decision-support are high-ceiling; automations are never penalized (see REFERENCE)
- Feasibility ← integration complexity · data readiness · adoption/change risk
- Time ← speed to a first working *result* (distinct from Feasibility)

Calibrated anchors with worked examples: **[REFERENCE.md](REFERENCE.md).**

**4. Classify (decision tree).** Tag a type and a catalog archetype; keep both backstage.
1. Owner's high-stakes judgment on proprietary data → **decision support** (A10 / V-series). Apply the **moat test**: could a $20/mo copilot do it? A low catalog-match on a top pick signals a premium opportunity, not a gap.
2. Repeatable doc/message task → **workflow automation** (A1/A5/A6/A7).
3. Watch / sort / track → **orchestration** (A3/A4/A9).
4. Capture knowledge → **knowledge-context foundation** (A8).
5. Mixed → **hybrid**, tagged honestly.

No fit → `UNLISTED — candidate`, one-line why, flag to operator. Never force-fit a high-value bespoke opportunity into a generic slot.

**5. Rank.** The ranked order is a **sequence — what to tackle first**, not a value chart, and **not a blind sum** of the scores. So a high-Impact but low-Feasibility opportunity (a capture-gated or integration-gated prize) is sequenced **below every viable higher-feasibility candidate** — it is an *expand*, ranked late even at Impact 5. Do not float a prize up the list to signal its worth: its worth goes in the **reasoning**, and the audit surfaces it narratively (the executive summary and the pilot's "what comes after"). Concretely, a Feasibility-2 item sits below the Feasibility-3+ candidates unless nothing else is viable. Tie-breaks, in priority: grounding/defensibility → Feasibility → adoption cleanliness → Time → strategic role. State each rank reason; name where an un-run session is the limiter.

**6. Pick the first pilot.** #1 = strongest *first* pilot, not the biggest prize: a clear measurable case with an agreeable baseline; first-engagement fit (low integration, clean adoption, no tooling fork, fast-ish proof); proprietary grounding (moat test for decision-support). **Pilot where Agentic Maison is differentiated** — AI agents and decision-support grounded in the client's proprietary data and judgment, over work the client's own IT could self-serve. A high-impact automation can be the right *finding* but the wrong *pilot*: if the client's IT could build it, or a commodity copilot already does it, it does not require AM's edge. This is a pilot-selection filter, not an Impact discount — the automation keeps its score. **Be precise about "the client's IT could build it":** that means deterministic scripting, system integration, RPA, or template/report generation — what a traditional IT team already does. It does **not** mean LLM-based extraction, cross-document judgment, or agentic decisioning, which are AM's domain even when the deliverable is described as an "automation." Do not demote an LLM/agent build on self-serviceability grounds just because its output looks like automation. Land vs expand is explicit — the biggest prize can sit at #4. Distinguish the first *pilot* from the first *deliverable*: a fast early win can ship alongside without being the pilot.

## Outputs

`discovery/opportunities.md` — the ranked, classified, scored set with reasoning, `[needs from client: ...]` gaps, and the killed list. It feeds the audit §1 table, §3 reasoning, and the Appendix derivation; the current-state map feeds §2. Keep backstage (not in the audit body): the type tag, archetype mapping, value type + metric, and adoption sub-factor. Backstage→client-axis mapping and the scorecard shape are in [REFERENCE.md](REFERENCE.md).

## Conventions

- Show scoring two ways in `opportunities.md`: a backstage scorecard table **and** per-opportunity reasoning prose.
- Plain names lead; taxonomy stays backstage (`ai/AGENTS.md` "Naming opportunities"). Pick the plain name from the catalog menu, never invent one.
- One pass, fresh eyes: create `opportunities.md` after all sessions are complete and score from the written files in a single deliberate pass. No incremental re-ranking after each interview (recency bias).
- Mark it DRAFT until operator review.
- No fabrication — use `[needs from client: ...]`; the limiter is usually the interview, not the synthesis.
