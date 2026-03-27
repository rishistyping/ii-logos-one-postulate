# Aristotle for This Repository

Aristotle by Harmonic is an automated theorem proving system for Lean 4. In this
repository, the safest way to use it is as a second prover and checker:

- validate the current Lean surface
- repair proof regressions if `sorry` placeholders reappear
- compare theorem statements against `paper/one-postulate.tex`
- formalize paper text into Lean sketches
- search for counterexamples before accepting theorem or prompt changes

## Proof-Surface Guard

Do not let Aristotle widen this repository's phase-1 proof surface.

- Do not import `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`.
- Use `OnePostulateFull.lean` and `OnePostulate/ClassificationDerivation.lean` separately for deferred or full-paper work.
- Treat Aristotle output as proposed code to review, not as something to merge blindly.

## When To Use Aristotle Here

Use Aristotle in this repository when you want to:

- check whether the current Lean outputs still build and match the paper
- validate a theorem statement against `paper/one-postulate.tex`
- search for a counterexample before editing a theorem statement
- fill future proof holes on a branch or in a local experiment
- formalize natural-language math notes before hand-finishing them in Lean

Do not use Aristotle to:

- bypass local Lean validation
- widen the phase-1 root
- change theorem statements without review
- store secrets or generated artifacts in tracked documentation

## Repo Quickstart

From the repository root:

```bash
lake exe cache get
lake build
rg -n 'sorry|admit' OnePostulateFull.lean OnePostulate.lean OnePostulate/*.lean
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
```

Then run Aristotle against the repo as a project:

```bash
aristotle submit "Validate the Lean project in this repository. Do not widen the phase-1 import surface. Check OnePostulate.lean, OnePostulate/ClassificationDerivation.lean, and OnePostulateFull.lean carefully. Do not change theorem statements unless you find a false statement and explain why." --project-dir . --wait
```

Review the result before accepting any change:

```bash
aristotle list
aristotle result <PROJECT_ID>
lake build
```

## Root Modules To Know

- `OnePostulate.lean`: phase-1 root
- `OnePostulateFull.lean`: full-paper root
- `OnePostulate/ClassificationDerivation.lean`: deferred bridge layer
- `GaussProofSandbox.lean`: preserved smoke-test root
- `Main.lean`: executable entry

## Current Validation Surface

This repository already uses these local checks:

- `lake update`
- `lake exe cache get`
- `lake build`
- `lake build OnePostulate`
- `lake env lean OnePostulate/ClassificationDerivation.lean`
- `lake env lean OnePostulateFull.lean`

The current CI also guards:

- `sorry|admit` in `OnePostulateFull.lean`, `OnePostulate.lean`, and `OnePostulate/*.lean`
- accidental import of `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`

Aristotle should complement those checks, not replace them.

## Doc Map

- [Installation and secrets](INSTALLATION.md)
- [Lean and Mathlib compatibility](LEAN_COMPATIBILITY.md)
- [CLI workflows](CLI_WORKFLOWS.md)
- [Python API workflows](PYTHON_API_WORKFLOWS.md)
- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)
- [Repository verification runbook](REPO_VERIFICATION_RUNBOOK.md)
- [Prompt templates](PROMPT_TEMPLATES.md)
- [Counterexamples and debugging](COUNTEREXAMPLES_AND_DEBUGGING.md)
- [CI and review flow](CI_AND_REVIEW.md)
- [Citation](CITATION.md)

## Suggested Reading Order

1. [Installation and secrets](INSTALLATION.md)
2. [Lean and Mathlib compatibility](LEAN_COMPATIBILITY.md)
3. [Repository verification runbook](REPO_VERIFICATION_RUNBOOK.md)
4. [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)
5. [CLI workflows](CLI_WORKFLOWS.md) or [Python API workflows](PYTHON_API_WORKFLOWS.md)
6. [Counterexamples and debugging](COUNTEREXAMPLES_AND_DEBUGGING.md)

## Archived validation runs

- Full-paper run [eaa48588-a529-405f-a871-13665c6b85c5](runs/eaa48588-a529-405f-a871-13665c6b85c5/README.md)
- [Aristotle summary](runs/eaa48588-a529-405f-a871-13665c6b85c5/ARISTOTLE_SUMMARY_eaa48588-a529-405f-a871-13665c6b85c5.md)
- [Validation report](runs/eaa48588-a529-405f-a871-13665c6b85c5/VALIDATION_REPORT.md)

## See Also

- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)
- [CI and review flow](CI_AND_REVIEW.md)
