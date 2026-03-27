# CI And Review

Back to [Aristotle docs home](README.md). See also [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md).

## How Aristotle Fits This Repo

Aristotle should complement this repository’s existing validation flow, not
replace it.

This repo already relies on:

- `lake build`
- targeted Lean checks for `OnePostulate/ClassificationDerivation.lean`
- targeted Lean checks for `OnePostulateFull.lean`
- a no-`sorry|admit` scan
- a phase-1 import guard that keeps `OnePostulate.ClassificationDerivation` out of `OnePostulate.lean`

Use Aristotle as an additional reviewer:

- to test theorem outputs
- to cross-check paper alignment
- to generate repair candidates
- to search for counterexamples

## Lightweight Review Workflow

Use this review loop:

1. Local build:
   - `lake exe cache get`
   - `lake build`
2. Aristotle run:
   - validate or repair the smallest useful scope
3. Diff review:
   - compare Aristotle output against local files
4. Second local build:
   - rerun `lake build`
   - rerun deferred/full-paper checks
5. PR review:
   - review theorem statements, imports, and comments

## What Aristotle Must Not Replace

Aristotle does not replace:

- `lake build`
- the repo’s `sorry|admit` guard
- the phase-1 import guard
- local review of theorem statements

If Aristotle says a change is valid but the local build disagrees, trust the
local build first and debug the mismatch.

## Proof-Surface Guard

Repeat this rule in review:

- do not import `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`
- use `OnePostulateFull.lean` and `OnePostulate/ClassificationDerivation.lean` separately for deferred/full-paper work
- Aristotle-assisted edits must not widen the phase-1 root by accident

## Optional Future Automation

Possible future automation ideas:

- a manual CI job that uploads a reviewed project snapshot to Aristotle
- a PR checklist item that records whether Aristotle was used
- a result-archive convention outside the tracked repo

These are optional process ideas only. This documentation does not change CI or
wire Aristotle into automation.

## See Also

- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)
- [Counterexamples and debugging](COUNTEREXAMPLES_AND_DEBUGGING.md)

