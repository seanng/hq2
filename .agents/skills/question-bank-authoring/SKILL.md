---
name: question-bank-authoring
description: Generate the pre-session question bank for an AI Practice Discovery workflow interview — build a per-seat spine of assert→drill questions from the client's source docs that probes two required, role-calibrated axes: the process axis (steps, handoffs, exceptions, time-sinks) and the decision/intelligence axis (which decisions the seat owns, where they decide under-informed, where they fly blind, what they would ask a sharp analyst on tap). For the owner/sponsor seat, the bank opens with mandate elicitation (Axis 0) — where the sponsor believes the opportunity is — and is weighted toward their stated priorities. Use during Step 1 of a Discovery engagement (Conrad), before the owner and stakeholder sessions. Triggers on "build the question bank", "prep the interview", "generate questions for <stakeholder>", "discovery prep".
---

# Question-Bank Authoring

Generate the pre-session question bank that Conrad pre-loads before a workflow interview. This is the **Step-1 prep procedure** in Discovery — the front of the lifecycle whose downstream counterparts are `grill-workflow` (the live session), `workflow-synthesis-scoring` (synthesis), and `audit-authoring` (the deliverable). It produces the artifact shaped by the template at `areas/agentic-maison/ai/_templates/ai-client-engagement/discovery/prep/question-bank.md`.

**Internal only.** This skill documents the question-generation mechanism, which `ai/AGENTS.md` marks unsayable to clients. Nothing here, and nothing about *how* the bank is built, ever appears in client-facing material. The bank itself never leaves our system.

**The template is the output shape; this skill is the procedure.** Stamp the per-interviewee bank from the template (`question-bank-<slug>.md`, slug shared with `../interviews/<slug>.md`); do not restate its layout here. Doctrine: `ai/AGENTS.md` ("Session shape", "Orient before drilling", two registers, forbidden vocabulary) wins on conflict.

## When to use

Step 1 of Discovery, after the engagement is scaffolded and the client's source docs (org chart, process docs, flowcharts, prior notes) are in hand, and a session is planned for a given seat. The bank is a **pre-loaded spine, not a script** — it materializes the pre-reading plus assert→drill hypotheses; the live `grill-workflow` loop improvises sequencing and follow-ups from it.

## The core mandate: two axes, both always present, weighted by seat

Every question bank drills **two axes — and the decision/intelligence axis is never optional, for any seat.** This is the load-bearing rule of this skill. A bank that maps the process but never the decisions the process serves is incomplete and must not go to session. For the **owner/sponsor seat** there is additionally a prior element — **Axis 0, the mandate** (below) — which opens the bank and steers how the two axes are weighted across domains.

**The weighting is role-calibrated, not equal.** The wrong fix here is "give every seat equal process and decision coverage" — that over-drills doer seats on decisions they do not own and under-serves the process detail you actually need from them. The right rule:

> **Every seat must expose its decision surface — the decisions it owns, where it goes under-informed, where it flies blind, the judgment that lives only in that person's head, and the intelligence that would change a call. But how much of the hour that surface earns is calibrated to the seat.**

Concretely:

- **Executive / leverage seats** (owner, GM, division head — anyone carrying a P&L, a target, or a portfolio call) get **heavy** decision/intelligence probing. This is where the fundable opportunity lives; the process detail is secondary line-of-sight. Lead with Axis B and hold it (orient before drilling), then drill Axis A only as far as it sizes the leverage.
- **Finance / analyst seats** sit in the middle: they *produce* analysis, so probe both what they can see and — sharper — what they cannot, alongside the process load (keying, reconciliation) that keeps them off analysis.
- **Operator / doer seats** (clerks, coordinators, schedulers) get **heavier Axis A** — their value to the audit is the honest process map and the time-sinks. But Axis B is still **explicit, not skipped**: even a doer owns micro-decisions ("which order do I work, when do I escalate, how do I know it's wrong"), holds undocumented judgment, and waits on intelligence that arrives late. Find that surface — lightly — and never let "they're just a doer" delete it.

The failure this prevents is the documented one: the room drifts to process and the decision lens gets abandoned. The defense is structural — **the bank is not complete until Axis B is present and seat-appropriate for every seat,** not just the executives.

### Axis 0 — Mandate (owner/sponsor seats only)

For the seat that commissioned the engagement — the owner, or whoever represents them — the bank opens with **mandate elicitation**, before any Axis A/B branch: what made them commission this, where they believe the opportunity or pain is (sales? company knowledge? decision support?), and what a win looks like. Three rules:

- **The mandate leads the sponsor bank.** Its opening section is mandate elicitation, marked "ask first; HOLD" — the same structural device the orient uses. Everything after it in the live session is steered by the answer.
- **Named priorities re-weight the bank.** If the source docs, the engagement scaffold, or a prior conversation already name the sponsor's priority areas, the bank's largest share of drills must target those domains — Axis A and Axis B applied *inside* the named domains, not to the sponsor's generic day-to-day. A sponsor bank that maps their personal workflow while ignoring their stated priorities is mis-built, whatever its axis balance.
- **The mandate is a hypothesis, not a script.** Include at least one assert→drill that tests the diagnosis itself ("you say sales — what's the evidence it's sales and not fulfilment?"), and keep a short closing sweep for leverage the sponsor didn't name. Owner-steered is not owner-limited — the audit's right to surprise them is part of what they're paying for.

**Proxy seats:** when the interviewee represents the owner rather than being the owner (a deputy, a family member, a chief of staff), the bank elicits *two* mandates — the owner's as relayed, and the proxy's own view — and includes a probe for divergence between them.

### Axis A — Process (steps, handoffs, exceptions, time-sinks)

How the work actually runs. Who triggers it, what handoffs happen, where exceptions go, what "done" looks like, where the time goes and where it stalls. This axis is well-understood and is the one the room drifts toward on its own.

### Axis B — Decision / intelligence (judgment, blind spots, leverage)

What the seat decides, and how well-informed those decisions are. For each seat, probe:

- **Decisions owned** — what calls is this person personally on the hook for?
- **Under-informed decisions** — which of those do they make without the information they wish they had?
- **Blind spots** — where do they fly blind, guess, or find out too late?
- **Analyst-on-tap** — what would they ask a brilliant analyst available on demand?
- **Proprietary head-knowledge** — what judgment lives only in their head, undocumented?
- **Decision-changing intelligence** — what information, if they had it reliably, would change a call they make?

Axis B is **structural, not an orient afterthought.** Doctrine names the failure mode directly ("Orient before drilling… the lens drifts; once the room gets into process, the orient questions get abandoned"). A one-paragraph reminder loses to a bank shaped only around process. This skill's defense is structural: the bank is not complete until Axis B is present and seat-appropriate for every seat (see the role-calibrated weighting above) — drilled heavily on the executive seats where the leverage lives, and present-but-light on the doer seats, never absent.

> **Why this matters commercially.** Decision-support / executive-leverage is a first-class, defensible, "wow" opportunity category (`ai/AGENTS.md`: "Score impact by value type, not by hours"). The process lens tends to surface modest time-sinks; the intelligence lens is what surfaces the fundable opportunity. The bank must give that lens first-class footing — present on every seat, and weighted heaviest where the leverage lives — by construction, not as an afterthought.

## Generation procedure

For each planned seat:

1. **Read the seat into focus.** From the client's source docs and the engagement `AGENTS.md` / `README.md`, establish what this seat does and where it sits in the org. Reuse, don't re-ask, anything the docs already answer.
2. **Lead with the mandate (sponsor seats).** If this is the owner/sponsor seat, draft the Axis-0 mandate-elicitation opening per the rules above, import any priority areas already on record, and re-weight the rest of the bank toward those domains before drafting a single generic process branch.
3. **Draft Axis A from the process.** Map this seat's steps/handoffs/exceptions; write assert→drill questions that push past the obvious answer to the binding constraint. Build each one on the **assert→drill rubric** below.
4. **Draft Axis B from the decision surface.** For each of the six Axis-B dimensions above, write probes specific to this seat's authority and domain, calibrated to the seat per the role weighting. Ground decision-support probes in the client's proprietary context (their numbers, pipeline, the knowledge in the owner's head) — a decision-support pilot that isn't so grounded is a commodity the CEO already has. Use the **per-seat probe libraries** below as the starting menu, then make every probe specific to this person.
5. **Balance check before ship.** Run the **seat-calibrated balance check** below. A bank that never surfaces this seat's decision surface is not ready, whatever its process depth.
6. **Reconcile the roster.** A per-interviewee bank is the first signal a session is planned; it must reconcile in the `../interviews/` session roster (per `prep/README` + `practice-conventions.md`).

## The assert→drill rubric — what makes a drill land vs. stall

The unit of the bank is not a question, it is an **assert→drill pair**: a stated hypothesis about how the seat works (drawn from the source docs and prior sessions) followed by a question that forces the interviewee to confirm, correct, or quantify it. The assert is the leverage — it shows we did the reading, and it converts a slow open question ("how do you buy?") into a fast correction ("we hear the real price comes from talking to factories, not published prices — true?"). A bare open question stalls; a wrong assert the interviewee corrects is *better* than a right one, because the correction is the signal.

A drill **lands** when it has these properties:

- **It carries a hypothesis the interviewee can disagree with.** "Walk me through the last big buy: how did you judge this was a good price?" beats "how do you decide what to buy?" — it anchors on a concrete event and a falsifiable claim.
- **It pushes past the first answer to the binding constraint.** The obvious answer arrives, and you keep going one more turn: where does the time *actually* go, where does it stall, what breaks it. The doctrine framing: "we don't stop when the obvious answer arrives; we keep going until we hit the actual constraint."
- **It asks for a number when value is at stake.** Anything that feeds an audit figure must be drilled to a band, not a sentiment. "Roughly what does one mistimed buy cost, and how many times a year?" — never settle for "it's expensive." Mark these `(quantify)` in the bank so the live loop knows not to let them pass.
- **It is grounded in *this* client's proprietary context.** "When a factory quotes you, where does that number go — anywhere others can see, or just with you?" lands because it tests a specific capture habit. A generic "do you track your data?" stalls.
- **It anchors on a concrete event or scenario, not the general case.** "Last time a plant reneged on a signed contract — what happened?" pulls truth; "how do you handle supplier issues?" pulls a press release.

A drill **stalls** when: it is a bare open question with no hypothesis; it accepts the first plausible answer without a follow-up turn; it asks for a feeling where a number is available; it is generic enough that any company in the industry could answer it the same way; or it is a yes/no the interviewee can close in one word without revealing the mechanism. If a drafted question can be answered "yes, that's right" and the session moves on no wiser, it is not a drill — add the follow-up turn that makes it one.

**Assert→drill is the Axis-A workhorse, but Axis B uses the same form.** A decision probe is sharpest as an assert→drill too: assert where you think they fly blind ("we hear you judge buy-timing on feel because published prices aren't reliable"), then drill ("which of those calls do you most wish you had better information for?").

## Per-seat decision/intelligence probe libraries (Axis B), by role

Starting menus, not scripts. Pick the dimensions that fit the seat's authority, make every probe specific to this person's domain and numbers, and weight per the role-calibrated rule. The worked examples are drawn from real banks — adapt, do not lift.

### Executive / leverage seat (owner, GM, division head — carries a P&L, a target, or a portfolio call)

Heavy Axis B. Lead here and hold it before process. The fundable opportunity usually surfaces here.

- **The seat itself, first.** Establish what the title actually carries before probing where it's blind — for a senior seat we have often only modelled one slice (e.g. "buyer") and missed the leverage. *"Beyond [the obvious function], what does [title] actually cover here — the team, a number you carry, the interface with [HQ/owner]? What does [owner] hold you accountable for?"*
- **Decisions owned + where they fly blind.** *"Which big calls must you make on information that isn't good enough — where are you, in effect, going on feel?"* This is the central executive probe; everything else supports it.
- **Analyst-on-tap.** *"If you had a brilliant analyst available 24/7 who could pull any analysis, what's the first thing you'd put them on?"* The single highest-yield Axis-B question — it surfaces the wished-for intelligence directly. Listen for the seat's own analogue of what the owner wanted (customer-growth tracking, portfolio steering, margin-by-segment).
- **The number they can't see.** *"Is there a number you wish you could see but can't today — margin by customer, by market, where prices are trending, what you're leaving on the table?"* Grounds the decision-support opportunity in a concrete missing metric.
- **Proprietary head-knowledge.** *"How do you decide which [suppliers / plants / customers] to trust — and where does that judgment live? Is it written anywhere, or is it in your head?"* Tests for a knowledge-capture seam under the leverage.
- **Decision-changing intelligence.** *"What information, if you had it reliably and on time, would change a call you make regularly?"*

### Finance / management-accounting seat

Middle weight — both axes substantial. They *produce* analysis, so the sharp move is to probe the gap between what they can see and what they cannot, and the keying load that keeps them off analysis.

- **What the business can't see.** *"What's a number the business would want but currently can't get — true landed cost per shipment, margin by line, by customer?"* Finance is often where opp-feeding data has to come from; this finds it.
- **Assemble-vs-analyse split.** *"When you produce the monthly numbers, how much is assembling and keying versus actually analysing? Where does the time go that you'd rather spend on analysis?"* This is the finance seat's decision-speed seam *and* a process-automation candidate in one probe.
- **Are they already the owner's data source?** *"What does [owner] come to you for — what numbers do they ask you to pull, and how often?"* Tells you whether finance is the substrate for an executive decision-support opportunity.
- **Error-cost as risk-avoided value.** *"How often does a costing come back wrong — under-costed so margin is lost, or over-costed so the quote loses? What does one wrong file cost?"* Converts a finance process into a risk-avoided figure.

### Operator / doer seat (clerk, coordinator, scheduler)

Heavier Axis A — the honest process map and the time-sinks are their value to the audit. But Axis B stays **explicit and light**, never deleted:

- **Micro-decisions they own.** *"When work piles up, how do you decide what to do first? When do you escalate versus handle it yourself?"* Even a doer makes sequencing and triage calls — and those are sometimes the buildable seam.
- **How they know something's wrong.** *"What tells you an order / a file / a shipment is off before it becomes a problem? How do you catch it?"* Surfaces the tacit checking judgment that an agent might encode.
- **Intelligence that arrives late.** *"What do you find out too late — something that, if you'd known earlier, would have saved a scramble?"* The doer's version of flying blind.
- **Undocumented judgment.** *"Is there a part of this only you really know how to do — that would be hard to hand to someone new?"* Tests for key-person knowledge worth capturing.

### Trader / commercial seat (buys and sells; carries a spread)

Heavy Axis B like an executive, but the decisions are commercial and continuous. Probe both sides — buyers get modelled as buyers and the *selling* half goes un-probed.

- **Both halves of the seat.** *"How split is your week between buying and selling? What share is each?"* — then probe the leverage on each.
- **Buy- and sell-timing on thin info.** *"What are the calls you make where the information just isn't good enough — where you're going on feel? When do you most wish you knew something you can't?"* Listen for buy-timing *and* sell-timing.
- **The spread they can't see.** *"Is there a number you wish you could see — your own trade margins, where prices are trending, what you're leaving on the table — that nobody puts in front of you?"*
- **Capture of price intelligence.** *"When a supplier quotes you, where does that number go? Anywhere the team can see it, or does it stay with you until you act?"* Often the live test of a "keeps it in his head" flag from a prior session.

## Seat-calibrated balance check (before ship)

A checklist, not a word-count. Before a bank goes to session, confirm:

1. **Axis B is present for this seat at all.** There is at least a real "decisions owned / where they fly blind" probe — no bank ships as a pure process map. This is the non-negotiable floor.
2. **The weighting matches the seat.** Executive/trader seat → Axis B leads and is the larger share; finance → both substantial; doer → Axis A leads but Axis B is explicit and light. If a doer bank has zero decision probes, or an executive bank is 90% process branches, it is mis-weighted — rebalance.
3. **The orient leads.** The bank's opening section probes the seat and its leverage *before* the first process branch, and says so (a "do this first; HOLD it" marker), so the live loop holds the orient before the room sinks into mechanism.
4. **Sponsor banks lead with the mandate and are weighted to it.** For the owner/sponsor seat only: the bank opens with Axis-0 mandate elicitation, and if priority areas are already on record, the largest share of drills targets those domains. A sponsor bank shaped around the sponsor's personal day-to-day instead of their stated priorities is not ready, whatever its Axis A/B balance.
5. **At least one Axis-B probe is grounded in this client's proprietary context** — their numbers, their pipeline, the knowledge in someone's head — not a generic "do you use your data" question.
6. **Every value-bearing drill is marked `(quantify)`** so the live loop pushes for a band, not a sentiment.
7. **Each axis pushes past the obvious answer.** Spot-check: pick three questions; if any can be closed in one word with the session no wiser, add the follow-up turn that makes it a drill.

If any of 1–4 fails, the bank is not ready. 5–7 are quality gates that sharpen a bank that is structurally sound.

## Inputs

- Client source docs (org chart, process docs, flowcharts, prior notes) — the raw material.
- Engagement `AGENTS.md` / `README.md` — client, owner, stakeholders, industry, engagement-specific decisions.
- `discovery/stakeholder-map.md` — who, role, decision authority, adoption risk (seeds Axis B authority probes).
- The shared starter bank (`prep/question-bank.md`) — seeds the per-interviewee banks.

## Outputs

- `discovery/prep/question-bank-<slug>.md` — the per-interviewee bank, both axes, stamped from the template.
- The shared `discovery/prep/question-bank.md` kept current as the business comes into focus (keep questions that earned their place; cut the ones that landed flat).

## Hand-off to the session

The bank feeds `grill-workflow` (Steps 2–3): Conrad asks one question at a time, the operator relays I/O, and follow-ups are improvised from the spine. Whatever the bank surfaces flows downstream to `workflow-synthesis-scoring` — where decision-quality / decision-speed / revenue are scored co-equally with time saved — and then to `audit-authoring`. Keeping Axis B first-class here is what gives synthesis a decision-support opportunity to score.

---

<!-- internal: do not share. Domain content marked [TODO: Conrad] is authored live by Conrad; Manny scaffolded this shell (frontmatter + two-axis structure + procedure outline) per the SOP roadmap ownership legend. -->
