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

A workflow grilling session is scoped to a single engagement folder. Look for existing artifacts there before asking.

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

If a `GLOSSARY-MAP.md` exists at the engagement root, the engagement spans multiple workflows or business units. The map points to where each context lives:

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

</supporting-info>
