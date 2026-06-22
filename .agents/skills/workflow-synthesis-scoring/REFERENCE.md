# Scoring Reference

Calibrated detail for the three axes in [SKILL.md](SKILL.md). Each level is described so scoring is reproducible across engagements.

## Value type — name it before scoring Impact

Name **how** the opportunity creates value and the metric you would measure it on, then score Impact on that metric:

`time saved` · `cost reduced` · `risk avoided` · `decision speed/quality` · `revenue`

Non-time value is scored on its own terms and is **never** discounted because the payoff is not hours. This is the single biggest departure from a naive rubric: it lets a decision-speed or margin opportunity outrank a clerical-hours task that moves no money. Under an hours-saved frame, an opportunity the owner spends few personal hours on scores poorly even when its decision value is high; scored on decision quality it can be the right pilot.

## Impact — 1-5 anchors

Judged on the named value type and its magnitude *relative to this business*.

- **5 — Transformative.** Moves a structural or top-line lever: a fractional gain on the firm's largest dollar base, or unlocking the owner's highest-stakes recurring decision.
- **4 — Strong.** Clearly material against a named metric; the owner would notice. Reshapes a recurring steering decision, or frees a meaningful slice of a scarce person's week **and** avoids a real risk.
- **3 — Solid.** A real, worthwhile gain, but bounded in magnitude or frequency — diffuse, slow-burning, or low-frequency.
- **2 — Marginal.** A genuine but small convenience; nice-to-have, not a needle-mover.
- **1 — Negligible.** Token value; would not justify a build on its own.

**Score Impact on value created, not on how it is built.**
- Automations are never penalized for being automations. A simple, non-intelligent automation of a high-frequency task that eats hours of staff time daily is a legitimate 5.
- Decision-support and intelligence-driven value are high-ceiling and first-class. Genuine judgment that improves the owner's high-stakes decisions is a 4-5; never discounted for saving no hours.
- Intelligence — judgment about when, what, and how, including the judgment embedded in an agentic (non-scripted) automation — raises Impact through the decision-quality value it creates.
- **Strategic leverage counts.** Magnitude is judged by how close the opportunity sits to the core value chain — the money, or a binding constraint on it. The same value on the critical path outscores it on a peripheral task. Beneficiary seniority matters *only* as a proxy for this leverage (senior decisions compound across the business), never as its own weight: a high-leverage staff automation can be a 5; a trivial executive convenience is not.
- **Magnitude scales with reach × frequency × criticality** — how many people or how much of the value chain it touches, how often, and how central it is. One person's couple of hours on a peripheral task is bounded (a 2-3), not a 4, unless it sits on a critical-path bottleneck. A 4-5 needs breadth, high frequency, or a binding constraint behind it.

The separate question of whether Agentic Maison is the right *builder* (versus the client's own IT, or a commodity copilot) is a **pilot-selection filter in the first-pilot rule, not an Impact discount.**

## Feasibility — 1-5 anchors

A roll-up of three sub-factors: **integration complexity · data readiness · adoption/change risk.** The binding (worst) sub-factor usually dominates, but use judgment. **Record adoption explicitly backstage** even though it folds into this number — it is what the audit's §5 stakeholder read speaks to, and the link breaks if it is invisible.

- **5 — Buildable now, near-zero friction.** Data exists in a known shape; a single willing, able user; no integration or write-path; no tooling fork; no capture problem.
- **4 — Bounded, known effort.** Light integration or a bounded rules/data problem; a willing champion; a minor adoption ask.
- **3 — A real, scoped obstacle.** A capture habit or foundation to establish, a medium adoption ask across more than one person, or one un-probed dependency.
- **2 — Gated.** A binding obstacle: tacit/unsystematized data (a capture problem), heavy integration, a tooling fork, or unheard/resistant adopters. A demo, not yet a pilot.
- **1 — Not feasible as scoped.** Multiple compounding blockers; needs a different shape entirely.

## Time — 1-5 anchors

How soon a **first working result** reaches the owner — the proof of value, not the full architecture. Distinct from Feasibility: a thing can be feasible but slow to first output, or quick to a first proof even if the full build is harder. If you reflexively give Time and Feasibility the same number, re-examine.

- **5 — Days to ~2 weeks.** First useful output almost immediately; data already arrives, ships as a brief/document.
- **4 — ~2-4 weeks.** A bounded build before first output, clear path.
- **3 — ~1-2 months.** Moderate setup (extraction pipeline, schema, light integration) before the first result lands.
- **2 — Several months.** A substantial build, or an unsolved capture/integration step, before anything useful appears.
- **1 — Open-ended.** No clear path to a first result, or dependent on a capability not yet built.

## Backstage scores → the audit's three client-facing axes

The audit table shows **Impact · Feasibility · Time**. Adoption risk is a Feasibility *sub-factor* client-side (folded into the number, surfaced person-by-person in §5), not a separate column. Keep a backstage scorecard in `opportunities.md` that exposes the sub-factors so the roll-up is auditable:

| # | Plain name | Type (backstage) | Value type + metric | Impact | Feas. | Time | Adoption | Rank reason |
|---|---|---|---|:---:|:---:|:---:|---|---|

The type tag, archetype/`UNLISTED` mapping, value type, and adoption sub-factor are thinking tools and audit trail — they stay in `opportunities.md`. The client reads plain names + the three axis scores + reasoning only.
