---
name: hq-prd-worker-lifecycle
description: Shared HQ worker lifecycle for PRD-driven tasks. Use when a specialist agent is dispatched against a PRD and needs to know when and how to update the PRD, including Work Log, Result, Handoff, and status transitions.
---

# HQ PRD Worker Lifecycle

This skill defines the standard worker-side lifecycle for HQ PRD execution. Pam remains the authority for planning, dispatch, and lifecycle policy. Workers use this skill to apply that policy consistently when operating on their assigned PRD.

## Scope

Use this skill when all of the following are true:

- You were dispatched against a specific PRD.
- The dispatch prompt includes the PRD path.
- You are responsible for executing the work, not planning or triaging the initiative.

Do not use this skill to:

- Create PRDs.
- Replan initiatives.
- Edit `AGENTS.md`.
- Edit any PRD other than the one assigned to you.

## Operating Rules

1. Treat the assigned PRD as the canonical task artifact for scope, constraints, and acceptance criteria.
2. Update the PRD at meaningful checkpoints, not as a play-by-play transcript.
3. Keep `Work Log` concise: key decisions, important tradeoffs, major outcomes, and review checkpoints.
4. Use `Result` for the final summary of what changed or what was produced.
5. Use `Handoff / Next Action` for anything another human or agent needs to know to continue.
6. If the task cannot be completed normally, record the issue clearly and move the PRD to `needs_attention`.

## When To Update The PRD

Update the assigned PRD in these situations:

- When you complete meaningful acceptance criteria.
- When you pause for human review or feedback.
- When you discover a material constraint, tradeoff, or deviation worth preserving.
- When you finish the task.
- When you cannot continue and need attention.

Do not spam the PRD with low-signal implementation notes.

## Section Rules

PRDs are read in Obsidian. Whenever you reference another vault note — a PRD, a research doc, a deliverable, a handoff — in Work Log, Result, or Handoff / Next Action, write it as a clickable wikilink: `[[note-name]]` or `[[note-name|display]]` (e.g. `[[handoff-mvp-architecture]]`, `[[hqd-004-cloud-api|hqd-004]]`). Use `[text](url)` only for external URLs. Never wikilink frontmatter fields. See the `obsidian-markdown` skill for syntax.

### Acceptance Criteria

- Check off each acceptance criterion you completed.
- Do not check off incomplete or partially complete items.
- An AC may only be marked `[x]` when all three conditions are met: (a) the verifying action was actually executed, (b) the output or result is captured verbatim in the Work Log (or referenced via an unambiguous pointer such as a Result-section link), and (c) the output actually demonstrates the criterion is satisfied.
- Never check an AC based on memory, intuition, a dashboard glance, or what "should be" the case. If you did not run the verifying command, the AC is not done. Example: `vercel domains inspect jbclimited.com` must be executed and its output recorded before checking off a "domain attached" AC -- claiming the output looks correct from memory is not sufficient.
- Every Work Log entry that justifies one or more AC checks must include the verbatim command and its output (or a clearly delimited quoted result for non-CLI verification).
- If you discover an AC was previously checked without sufficient evidence (yours or another worker's), uncheck it and add a Work Log entry explaining why.
- Partial or inferred checks ("looks fine in browser" without specific verification) must remain unchecked, with a follow-up note in Handoff / Next Action.

### Work Log

Append concise entries covering:

- Important decisions.
- Notable implementation or research outcomes.
- Deviations from the original plan that matter for future readers.
- Review checkpoints and what feedback is needed.

Do not turn `Work Log` into a command transcript.

### Result

Use `Result` when finalizing work. Include:

- Summary: what you delivered.
- Files Modified: changed files or artifact paths.
- Discoveries: anything future work should know.

If the task is paused for review rather than finalized, `Result` may remain partial or empty unless your agent-specific workflow says otherwise.

### Handoff / Next Action

Write this section when:

- The operator needs to review something.
- Another agent will continue the work.
- There is follow-up context worth preserving.
- You are blocked and need a decision or prerequisite.

Be explicit about what happened and what is needed next.

## Ephemeral Artifacts

Workers sometimes produce transient files during execution: screenshots, debug HTML, dig dumps, CLI inspection output, scratch logs. These must not leak into the project root or the vault.

- Write all scratch artifacts to `<working_path>/.scratch/` only. Never write them to the project root, the vault root, or anywhere outside `<working_path>`. Example: a Playwright screenshot goes to `<working_path>/.scratch/vercel-deploy-full.png`, not the vault root.
- Before writing to `.scratch/`, add `.scratch/` to the project's `.gitignore` if it is not already present. Nothing in `.scratch/` should ever be committed.
- Clean up `.scratch/` (`rm -rf` it) before transitioning the PRD to `review` or `done`. The folder must not exist when the PRD is closed.
- If a verification artifact is genuinely valuable as evidence for the Result section, summarize it textually or link to a permanent location. Do not leave binaries in the working tree.

## Status Transitions

Update PRD frontmatter according to the actual state of the work:

- If you are pausing for human review, set `status: review`.
- If the work is complete and `review_mode: self`, set `status: done`.
- If the work is complete and `review_mode: human`, set `status: review`.
- If you cannot complete the work normally, set `status: needs_attention`.

In all cases above, also update `updated` to today's date.

## Completion Checklist

When finishing or pausing:

1. Check off completed acceptance criteria.
2. Append concise key decisions and outcomes to `Work Log`.
3. Write or update `Result` when finalizing.
4. Write `Handoff / Next Action` if review, follow-up, or context is needed.
5. Remove `.scratch/` if it exists (`rm -rf <working_path>/.scratch/`).
6. Update frontmatter status and `updated` date to match the current state.

## Failure Handling

For minor issues:

- Make a reasonable choice.
- Document the choice in `Work Log` or `Result`.

For major issues:

- Explain the blocker clearly in `Work Log`.
- Add the needed action or recommendation in `Handoff / Next Action`.
- Set `status: needs_attention`.

### Missing Tool Authentication / Brokered Tools

When a required tool or brokered capability reports not-authenticated or unavailable (for example, Tavily web research returns an auth error, or a CLI reports "not authenticated"):

- Do **not** silently fall back to a lesser substitute when the substitution materially changes the quality, coverage, or trustworthiness of the deliverable.
- Treat it as a hard stop: set `status: needs_attention` and, in `Handoff / Next Action`, name the **exact command the operator must run** to fix it, and state plainly that it requires the human operator (the agent cannot self-authenticate).
- A substitute is only acceptable when it genuinely suffices for the PRD's scope (e.g. `WebSearch` is adequate for a given research task). Even then, you must record in `Work Log` that the preferred tool was unavailable, which substitute you used, and any quality impact — so Pam and the operator can decide whether to re-run once the tool is authenticated.
