---
name: readout-authoring
description: Assemble the two-part live readout presentation that closes an AI Practice Discovery engagement — a self-contained HTML web deck plus an internal leader script — built as a pitch on a persuasion flow: each of the client's issues paired with its answer → the narrowing to the one issue carrying the most revenue → the recommended pilot → that pilot's projected impact by visible arithmetic → the path beyond → pilot timeline. Use during Step 6 of a Discovery engagement (Conrad), after the audit is FINAL. Triggers on "build the readout", "readout deck", "presentation deck", "readout script", "prepare the presentation".
---

# Readout Authoring

Assemble the live presentation that closes a Discovery engagement. This skill is the presentation counterpart to `audit-authoring`: the audit is the **evidence leave-behind** — it must survive being re-read cold or forwarded to a skeptic; the readout is the **pitch** — its job is comprehension, premium signal, and pilot conversion. Different genre, different structure. The readout is **not the audit read aloud**, and it must never contradict the audit: every claim in the deck must trace to the audit body, `opportunities.md`, or arithmetic shown on the slide from the client's own figures.

Doctrine (wins on conflict): `ai/AGENTS.md` (two registers, forbidden vocabulary, naming) and `2-discovery/README.md` Step 6 (two-part shape, gating).

## When to use

Step 6 of Discovery: the audit has been through operator review (FINAL, or an operator-approved DRAFT when the timeline demands it), the pilot proposal exists as its own artifact, and the presentation date is booked or being booked.

## Inputs (all internal — only the deck ships)

- `discovery/sources/audit.md` + the rendered PDF — the evidence base; the PDF is handed over at the end of Part 1
- `discovery/synthesis/opportunities.md` — ranked set, reasoning, and the **mandate block** at its head (sponsor's stated win, priority domains, annual sales/revenue baseline — see `workflow-synthesis-scoring`)
- the owner-session note in `discovery/interviews/` — the mandate, the issues, and any "lean-in moment" **in the owner's own words**; the readout quotes verbatims from here
- `discovery/sources/pilot-proposal.md` — Part 2 material and the source for the pilot timeline shape; commercial terms stay out of the deck
- engagement `AGENTS.md` / `README.md` — attendees, dates, tier, coverage bounds, business-unit structure
- `discovery/stakeholder-map.md` — who is in the room and what each attendee needs to hear (feeds the script, not the deck)

## The flow — six movements, in order

The deck pairs each of the client's problems with its answer, narrows to the one worth doing first, and only then prices that one thing. Each movement may span multiple slides or multiple reveal steps within a slide (see the template's design rules); the order is fixed.

1. **Issues and Opportunities.** The client's business issues, framed **from their perspective, not ours** — the problems as they experience them, each led by its own figure and each **paired with its answer as an outcome**. Diagnosis and response occupy one frame. The client's headline distress figure frames the section from above rather than sitting in the grid (template: the paired grid). Owner **verbatim quotes** may anchor a row, quoted honestly and never embellished. The evidence confirms what they already feel; the deck plays it back sharpened.
2. **The Narrowing.** Of the issues named, which single one carries the most revenue — argued on the client's own operating figures, ending on one recommendation. This is where the deck earns the right to propose rather than survey, and it is why the recommendation lands as a conclusion rather than a preference.
3. **The Recommended Pilot.** What it is and how it runs, shown as a **before/after pair of flow diagrams** — the workflow as it runs today (from the current-state note in `discovery/workflows/`), then the same workflow with the pilot in it, nodes aligned so the client sees exactly what changes and how little of their process moves. The before-diagram is their own process played back: get the operational owner in the room to confirm it is accurate before revealing the after, because their agreement is worth more than our description. The case for *why this pilot first and why it is low-risk* is **spoken, not on the slide** — it carries no on-slide annotation, so the leader script must hold it verbatim.
4. **Projected Impact.** What that specific pilot is worth, built by visible arithmetic as a staged chain: capacity returned → that capacity valued → the descent to what credibly converts. Rules below.
5. **The Path Beyond the First Pilot.** The sequenced expansion toward the full prize.
6. **Pilot Timeline.** A visual timeline of the pilot itself (weeks, milestones, first working result) — the plan made concrete. Timeline shape from the pilot proposal.

**No commercial terms in any movement.** No fee, price, cost-versus-return comparison, or investment figure appears anywhere in the deck — including in the projection, where the temptation is strongest because return-against-cost is a satisfying close. Part 1 must stand free so Part 2's disclosure stays client-elected (`2-discovery/README.md`, Step 6). Pricing belongs to the Part 2 one-pager.

**When the findings redirect the mandate** (the mandate is a hypothesis — `grill-workflow`): movement 1 still leads with what the client believes and says, and does the redirect work explicitly — "you pointed at X; the evidence says the road to X runs through Y." Sharpen, never flatter, never silently substitute.

## Projected Impact — persuasion without fabrication

This movement sells the upside, so its discipline matters most. The **enforcement device is the calc line** — canonical in `readout-template.md` ("Visible arithmetic"), which governs how a derivation is set on the slide. The judgment rules:

- **Every figure derives from the client's own numbers, and shows its derivation on the slide.** Start from the operational figures the client gave in session (volumes, time bands, headcount, shares) and the annual revenue baseline (mandate block). One inference per line; a figure three inferences deep shows three lines.
- **Assume only what the audit already conceded.** The projection must not quietly assume away limits the audit states — a human-review step, a manual tail, work that does not compress. If the audit says a pilot recovers part of a time band, the projection recovers part of it. A deck that contradicts the audit's own honesty is the fastest way to lose a skeptical sponsor.
- **Label what a figure is.** Capacity returned is not revenue unlocked. The most common failure in this movement is sound arithmetic carrying a false noun: a share of time multiplied by total revenue is the *value of the capacity freed*, never incremental revenue. Reframing the label usually rescues the number.
- **Size the lever against the slice it actually acts on.** Where most of the book is inbound, recurring, or otherwise not won by the effort the pilot frees, the projection applies to the addressable slice, not the whole. Naming that slice is a credibility gain, not a concession.
- **Descend to the floor in named steps, and range the floor.** An upper bound may open the chain provided each haircut below it is a labeled line with a reason. An arbitrary fraction ("even a tenth of this") reads as an admission the headline is soft — replace it with principled steps. Never state a multiple the client could not reconstruct from their own data plus the stated assumptions.
- **Never fabricate an input.** No invented benchmarks, no industry averages dressed as client facts, and no assumed client figure — labeling a fabrication "hypothetical" does not license it. Where an input was never captured, leave the slot visibly empty and **ask the room live**; the client's own answer is both more defensible and more engaging than an assumption. By default, if the revenue baseline was never captured, stop and flag to the operator. **Exception (operator override):** where the operator has explicitly waived the revenue baseline (the waiver rule and its conditions are canonical in `grill-workflow`, "Open with the mandate"), size against the named operational metric the client did give — same rules, never a substituted revenue estimate. Where the operator instead elects to **show** an uncaptured or relayed figure, it is attributed as an estimate and kept **non-load-bearing**: the mechanism rests on figures the client gave, so disputing the estimate does not collapse the projection.
- The projection also informs pilot pricing, but fee logic stays out of the deck entirely.

## Deck shape — the template is the spec

`areas/agentic-maison/ai/2-discovery/readout-template.md` is the single source of truth for the deck's shape: the **canonical section flow** (fixed section titles, movement mapping, per-section sources), the **slide design rules**, the **titles-and-tone hard rule**, and the **build conventions** (self-contained HTML, brand tokens, present mode). Build from it; do not restate or re-order its sections here — the same shape-vs-procedure split as `audit-template.md` and `audit-authoring`.

## The leader script (internal)

Alongside the deck, draft a spoken script to `discovery/workspace/readout-leader-script-INTERNAL.md` — internal register, never shared. The deck carries no appendix, so the script is the **only** place the deck's omitted depth lives, and it must be rehearsable rather than merely complete. It carries:

- The **per-attendee read** — who decides, who blocks, what each needs to hear (from the stakeholder map).
- One concrete **anecdote from the interviews** per movement.
- The **assumptions behind every projected figure**, and the reason for each haircut in the descent.
- **The coverage and methodology answer, rehearsed.** With no Discovery Process slide, a challenge to our depth ("you only spoke to three people?") has nothing to point at. The script carries the session date, the seats captured, the seats explicitly not held, and the chosen zones — deliverable spoken, in one calm paragraph, plus the pointer that the written audit states the same bounds.
- **The live asks.** Where a slide carries a deliberately empty slot, the exact question to put to the room, who to put it to, and the pre-computed outcomes across the plausible range of answers — so the arithmetic resolves in the moment without visible calculation.
- The **Part 1→Part 2 transition cue** (present the pilot proposal **only if** the room warms during Part 1), and the reminder that no price exists anywhere in Part 1's slides.
- A rehearsed **objection/Q&A bank** with verbatim rebuttal lines — including a direct challenge to the projection ("where does that number come from?"), answered with the on-slide arithmetic, and a challenge to the figure the client never supplied, answered by conceding it and showing the mechanism does not depend on it.

## Register and checks

Deck register is **customer-facing** (`ai/AGENTS.md`): plain, direct, evidence-led; plain opportunity names only (taxonomy stays backstage); no maison lexicon; no em-dashes (sub-bullets use colons); external label is "workflow interview" / "interviews". Before ship:

- Grep the deck against the forbidden-vocabulary list and confirm zero hits.
- Grep for the **internal offer ladder** — "Company Brain", "Agentic Workers", "Ops Layer". These are our internal three-level product names (`ai/AGENTS.md`, Three-level offer) and are as out-of-bounds client-facing as the opportunity-type taxonomy. Replace with the plain outcome.
- Grep for **any commercial term** — fee, price, cost, investment, a currency figure attached to our work. Zero hits in Part 1.
- Verify every number traces to the audit, `opportunities.md`, or on-slide arithmetic from client figures, and that each derived figure carries its calc line.
- Verify no figure in the deck **contradicts a limit the audit concedes**.
- Verify verbatim quotes match the session note exactly.
- Verify the issue set **tracks the audit's ranked opportunities**. A ranked opportunity missing from the grid, or a Further-Opportunities tail mention given a full row, is permitted **only on an explicit operator decision recorded in the engagement** — never as a silent divergence. Check for both, and if either is present, confirm the decision exists.
- Grep the deck's **HTML comments** for internal register. Build notes, doctrine references, superseded filenames, internal token or palette names, and process rationale all leak into a client-visible file where no one thinks to look. Comments in a shipped deck should say nothing an operator would not put on a slide.
- Verify opportunity names and outcome phrasings do not misrepresent the audit's named opportunities (a deck-only rename is an operator decision, not a silent edit).
- No `[needs from client:]` anywhere. A deliberately empty slot for a live ask is not a placeholder — it is designed, and the leader script carries its question.
- Step through **every reveal step**, then view fully-built, and confirm both read correctly and carry the same argument.
- Run the design rules as a checklist (one message per slide, no dense paragraphs, house typography throughout).

## Outputs

- `discovery/shared/readout-<slug>.html` — the deck (ships; presented live, never emailed ahead)
- `discovery/workspace/readout-leader-script-INTERNAL.md` — the spoken script (internal)
- The pilot proposal one-pager remains a separate artifact with conditional disclosure (Part 2) — never bundled, referenced, or previewed in Part 1.
