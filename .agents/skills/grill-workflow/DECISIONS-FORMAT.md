# Decisions Format

Decisions live in `decisions/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, etc.

Create the `decisions/` directory lazily — only when the first decision qualifies.

## Template

```md
# {Short title of the decision}

**Date:** YYYY-MM-DD

{1-3 sentences: what's the context, what was decided, and why.}

**Why it's hard to reverse:** {one line}
**Why a future reader would be surprised:** {one line}
**What the trade-off was:** {one line — the genuine alternative and why it was rejected}
```

That's it. A decision can be a single paragraph plus the three one-liners. The value is recording *that* a decision was made and *why* — not filling out sections.

## Numbering

Scan `decisions/` for the highest existing number and increment by one.

## When to offer a Decision

All three must be true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If a decision is easy to reverse, skip it. If it's not surprising, nobody will wonder why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing."
