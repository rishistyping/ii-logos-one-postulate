# Lean Validation Workflow

Back to [Aristotle docs home](README.md). See also [Prompt templates](PROMPT_TEMPLATES.md).

## Purpose

This document explains how to use Aristotle as a second prover and checker for
this repository. The goal is not just to generate Lean code. The goal is to:

- validate the current Lean surface
- catch theorem-statement drift
- compare Lean code against `paper/one-postulate.tex`
- repair branch-local proof regressions if they appear
- find counterexamples before accepting a change

## When to use Aristotle in this repo

Use Aristotle when you want to:

- check a branch after substantial Lean edits
- validate `OnePostulate/ClassificationDerivation.lean` and `OnePostulateFull.lean` without widening phase 1
- compare theorem statements against `paper/one-postulate.tex`
- investigate whether a failure is a false statement, a missing lemma, or an environment issue
- fill future `sorry` placeholders if they ever reappear on a branch

Do not use Aristotle as a reason to relax the repo’s proof-surface rules:

- do not import `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`
- do not let Aristotle-assisted edits widen the phase-1 root
- validate deferred and full-paper work through `OnePostulate/ClassificationDerivation.lean` and `OnePostulateFull.lean` separately

## Preflight checklist

From the repository root:

```bash
lake exe cache get
lake build
rg -n 'sorry|admit' OnePostulateFull.lean OnePostulate.lean OnePostulate/*.lean
grep -nE '^[[:space:]]*import[[:space:]]+OnePostulate\.ClassificationDerivation([[:space:]]|$)' OnePostulate.lean || true
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
```

If any of those checks fail, fix the local repo first. Aristotle output is much
harder to review when the local baseline is already red.

## Validate the current Lean surface

Use a repo-root project submission:

```bash
aristotle submit "Validate the Lean project in this repository. Do not widen the phase-1 import surface. Keep OnePostulate.lean free of OnePostulate.ClassificationDerivation. Review OnePostulate.lean, OnePostulate/ClassificationDerivation.lean, and OnePostulateFull.lean carefully. Do not change theorem statements unless you find a false statement and explain why." --project-dir . --wait
```

Then inspect the job:

```bash
aristotle list
aristotle result <PROJECT_ID>
```

For phase-1 checks, review output against:

- `OnePostulate.lean`
- `OnePostulate/SpacetimeRepresentation.lean`
- `OnePostulate/Selection.lean`

For deferred or full-paper checks, review output against:

- `OnePostulate/ClassificationDerivation.lean`
- `OnePostulateFull.lean`

Keep those surfaces separate during review.

## Use Aristotle to fill proof holes

This repository currently has no `sorry` or `admit`, so this workflow is for
future regressions, exploratory branches, or local repair work.

Project-wide hole-filling prompt:

```bash
aristotle submit "Fill the remaining proof holes in this Lean project. Preserve theorem statements, preserve imports, and do not widen the phase-1 root." --project-dir . --wait
```

Single-file repair prompt:

```bash
aristotle submit "Repair proofs in OnePostulate/Selection.lean only. Preserve theorem statements. Do not widen imports or change the repo's proof-surface boundaries." --project-dir . --wait
```

After any hole-filling attempt:

```bash
lake build
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
```

## Use Aristotle to validate theorem statements against the paper

For paper alignment, use both the repo and the paper source:

```bash
aristotle submit "Validate theorem statements in this repository against paper/one-postulate.tex. Focus on statement alignment first, then proof alignment. Do not widen imports. If a statement appears false or mismatched, explain the mismatch rather than silently rewriting imports." --project-dir . --wait
```

For a paper-first formalization attempt:

```bash
aristotle formalize paper/one-postulate.tex --wait --destination formalized-paper.tar.gz
```

Use the formalized output as review material. Do not merge it directly without
local Lean validation and statement comparison.

## Use Aristotle to search for counterexamples

When you suspect a statement is wrong, say so explicitly:

```bash
aristotle submit "Search for a counterexample or a proof of the negation for the target claim in OnePostulate/ClassificationDerivation.lean. If the statement is false, explain that and do not widen imports." --project-dir . --wait
```

Use this mode before changing theorem statements by hand. A counterexample often
reveals whether the problem is:

- the statement itself
- a missing hypothesis
- a hidden dependency on a stronger import surface

## How to compare Aristotle output with local Lean code

First inspect the result:

```bash
aristotle result <PROJECT_ID>
```

If your CLI version produces a downloadable bundle, unpack it outside the repo:

```bash
mkdir -p /tmp/aristotle-review
tar -xzf result.tar.gz -C /tmp/aristotle-review
```

Then compare it with your working tree:

```bash
diff -ru /tmp/aristotle-review /Users/rish/Documents/codebases/one-postulate-lean
git diff --word-diff
```

Check specifically for:

- theorem statement edits
- new imports
- accidental import of `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`
- edits that blur the difference between `OnePostulate.lean` and `OnePostulateFull.lean`
- negation or counterexample comments

## How to review and merge Aristotle-assisted changes

Use this review sequence:

1. Run the local preflight.
2. Run Aristotle on the narrowest useful scope.
3. Review the result before copying or applying anything.
4. Rebuild locally.
5. Re-check `OnePostulate/ClassificationDerivation.lean` and `OnePostulateFull.lean`.
6. Inspect theorem statements and imports by diff.
7. Reject any output that widens the phase-1 root by accident.

Accept Aristotle-assisted changes only if all of these remain true:

- `lake build` passes
- theorem statements are unchanged unless you intentionally reviewed a false one
- phase-1 import boundaries are intact
- no live secrets appear in the repo

## Failure modes and what they usually mean

### Local build fails before Aristotle runs

Your repo baseline is already broken. Fix local Lean first.

### Aristotle proposes a proof but local Lean rejects it

Likely causes:

- stale local cache
- changed imports
- output depends on a different surface than the repo allows
- theorem statement drift

### Aristotle inserts negation or counterexample comments

Treat that as a serious signal that the target claim may be false, underpowered,
or paper-misaligned. Investigate before changing code.

### Aristotle reports completion with weak or partial output

Often means:

- missing lemma decomposition
- toolchain or parser mismatch
- insufficient context
- budget exhaustion

### Aristotle hits `OUT_OF_BUDGET`

Narrow the follow-up run:

- one file instead of the whole repo
- one theorem instead of one file
- deferred/full-paper surfaces separately from phase 1

### Aristotle output uses comments but the proof is still bad

Remember the review model:

- theorem-header comments can guide Aristotle
- comments inside proof blocks are not a reliable guidance channel

If you need to steer the model, use theorem-header comments or a better prompt,
not proof-body commentary.

### Aristotle produces `aesop`-heavy output with warnings

Treat warnings as a second pass problem. First confirm the proof is correct and
fits the repo surface. Then request cleanup or warning suppression explicitly in
a narrower follow-up prompt.

## See Also

- [Prompt templates](PROMPT_TEMPLATES.md)
- [Counterexamples and debugging](COUNTEREXAMPLES_AND_DEBUGGING.md)

