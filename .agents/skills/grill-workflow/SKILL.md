---
name: grill-workflow
description: Workflow grilling session for operators, owners, and stakeholders. Interview a business about how a workflow actually runs, sharpen fuzzy terminology, build a per-engagement glossary inline, and record load-bearing business decisions. Use when scoping a consulting engagement around a workflow, running an operations interview, stress-testing how an executive's team actually executes a process, or maintaining a per-client domain glossary.
---

<what-to-do>

Interview the operator relentlessly about every part of this workflow until you reach a shared understanding. Walk down each branch of the process — who triggers it, what handoffs happen, where exceptions go, what "done" looks like — resolving dependencies between steps one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by reviewing interview transcripts, prior notes, or public-facing artifacts the user has pointed at, do that instead.

</what-to-do>

<supporting-info>

## Domain awareness

A workflow grilling session is scoped to a single **context root** — the folder that owns the glossary and decisions for what you're grilling. Look for existing artifacts there before asking.

The context root is usually the engagement folder itself, but a host system may anchor it at a subfolder it designates. (For example, an AI-Practice engagement anchors the context root at `discovery/`, keeping internal grilling artifacts separate from customer-facing exports elsewhere in the folder.) The structures below are shown **relative to the context root**, wherever the host anchors it.

### File structure

Most engagements have a single context:

```
<engagement-root>/
├── GLOSSARY.md
├── decisions/
│   ├── 0001-flat-fee-pricing.md
│   └── 0002-owner-signs-off-each-stage.md
└── interviews/
```

If a `GLOSSARY-MAP.md` exists at the context root, the engagement spans multiple business units or sub-domains whose vocabularies genuinely diverge — the trigger is that **the same term carries a different definition in each context** (e.g. "account" means one thing to billing and another to ordering). When that's true, each context owns its own glossary so the definitions don't fight; a single shared glossary would force constant drift. When the workflows share one vocabulary — even if there are several of them — keep the single-context shape above. The map points to where each context lives:

```
<engagement-root>/
├── GLOSSARY-MAP.md
├── decisions/                         ← engagement-wide decisions
└── workflows/
    ├── accounts-payable/
    │   ├── GLOSSARY.md
    │   └── decisions/                 ← workflow-specific decisions
    └── client-onboarding/
        ├── GLOSSARY.md
        └── decisions/
```

Create files lazily — only when you have something to write. If no `GLOSSARY.md` exists, create it when the first term is resolved. If no `decisions/` exists, create it when the first decision qualifies.

## During the session

### Challenge against the glossary

When the interviewee uses a term that conflicts with the existing language in `GLOSSARY.md`, call it out immediately. "Your glossary defines 'client' as the buyer's company, but you just used it to mean the individual signing the SOW — which is it?"

### Sharpen fuzzy language

When the interviewee uses vague or overloaded terms, propose a precise canonical term. "You're saying 'the team' — do you mean the operations pod or everyone on the engagement? Those are different groups."

### Drill the decisions, not just the steps

A workflow map tells you how the work moves; it does not tell you what the work is *for*. Every process exists to serve decisions someone is on the hook for — and those decisions are where the leverage usually hides. As you walk the steps, keep asking what the person at each step decides, and how well-informed that decision is. Probe: which calls do they own, which do they make on information that is not good enough, where do they go on feel, what do they find out too late, and what would they ask for if they had a sharp analyst on tap. Do this for every role, sized to the seat — a senior owner makes high-stakes judgment calls all day, but even a clerk owns micro-decisions (what to work first, when to escalate, how they know something is wrong). The process map will try to crowd these out: once the room is deep in mechanics, the decision questions get abandoned. Hold them. The step that takes the longest is not always the one that matters most; the decision made with the worst information often is.

### Discuss concrete scenarios

When workflow relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases — what happens on a Friday afternoon, what happens when the approver is on holiday, what happens when the invoice arrives before the PO — and force the interviewee to be precise about the boundaries between steps and roles.

### Cross-reference with prior statements

When the interviewee states how something works, check it against earlier statements in this session, prior interview notes, and public-facing artifacts (website, LinkedIn, press, anything the user has pointed at). If you find a contradiction, surface it: "Earlier you said invoices go to AP first, but you just said your assistant approves them — which is the actual path?"

### Update GLOSSARY.md inline

When a term is resolved, update `GLOSSARY.md` right there. Don't batch these up — capture them as they happen. Use the format in [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md).

`GLOSSARY.md` should be totally devoid of process steps, scratch notes, or implementation thinking. Do not treat it as a spec, a meeting log, or a proposal draft. It is a glossary and nothing else.

The glossary is **internal-only**. Never share it back to the interviewee unless they explicitly ask to see it. The quality of your downstream artifacts is the proof that the glossary did its job.

### Offer Decisions sparingly

Only offer to capture a Business Decision when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip it. Use the format in [DECISIONS-FORMAT.md](./DECISIONS-FORMAT.md).

## Before closing the session — live confirm pass

While the interviewee is still in the room, do a short wrap before you end the call. Its job is to close the cheap gaps in person rather than punt them to an async follow-up. Quickly:

- **Confirm the decisions you are unsure you got right** — "so the call on X is yours, and you make it weekly off the spreadsheet — did I get that right?"
- **Pin the one or two numbers or facts that are cheap to ask now** — a quantity, a frequency, a threshold you left fuzzy.
- **Surface any contradiction you noticed** while it can still be resolved live.

Keep it to the handful of items that genuinely close in under a minute each. Anything heavier — a whole topic you did not reach, a number they would need to look up — is for the async follow-up, so you are not keeping the interviewee on the clock. The deeper reflection happens after, off the clock (next).

## After the session — debrief pass

Once the session ends, before you move on, run a short debrief while the conversation is fresh. This is a quality check that the decision lens was not crowded out by the process map, and it catches what to follow up on. For each session, answer:

- **What decision did this person actually own?** Name the calls they are on the hook for — not the steps they run. If you cannot name one, the session stayed on process and the decision lens was missed.
- **What intelligence gap did we surface?** Where do they decide under-informed, go on feel, find out too late, or wish they had a number or signal they cannot see today? Name it concretely.
- **What blind spot remains unprobed?** What did the session not get to — a decision you suspect they own but did not confirm, a quantity you did not pin down, a contradiction left unresolved? This is the follow-up list.

Capture the answers wherever the host system files session notes. If all three come back thin, that is the signal to schedule a follow-up or steer the next session harder onto the decisions the work serves.

</supporting-info>
