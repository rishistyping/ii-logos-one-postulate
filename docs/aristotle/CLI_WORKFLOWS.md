# CLI Workflows

Back to [Aristotle docs home](README.md). See also [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md).

## Before You Start

From the repository root:

```bash
lake exe cache get
lake build
```

If you use an environment variable for credentials:

```bash
export ARISTOTLE_API_KEY="<YOUR_ARISTOTLE_API_KEY>"
```

Do not commit secrets. Do not paste live keys into tracked files.

## Proof-Surface Guard

Repeat this rule before every Aristotle run on this repo:

- do not widen the phase-1 root
- do not import `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`
- use `OnePostulate/ClassificationDerivation.lean` and `OnePostulateFull.lean` separately for deferred or full-paper validation

## Validate The Lean Project

Use Aristotle as a checker for the current repo state:

```bash
aristotle submit "Validate the Lean project in this repository. Do not widen the phase-1 import surface. Keep OnePostulate.lean free of OnePostulate.ClassificationDerivation. Check OnePostulate.lean, OnePostulate/ClassificationDerivation.lean, and OnePostulateFull.lean carefully. Do not change theorem statements unless you find a false statement and explain why." --project-dir . --wait
```

This is the safest default project-level run for this repository.

## Fill Future Proof Holes

This repo currently has no `sorry` or `admit`, but if proof holes reappear on a
branch, use a scoped repair prompt:

```bash
aristotle submit "Fill the remaining proof holes in this Lean project. Preserve theorem statements. Do not widen imports. Keep OnePostulate.lean free of OnePostulate.ClassificationDerivation." --project-dir . --wait
```

For a narrower repair:

```bash
aristotle submit "Repair proof holes in OnePostulate/Selection.lean only. Preserve theorem statements and imports." --project-dir . --wait
```

## Validate Deferred And Full-Paper Surfaces

For work that touches deferred or full-paper material, say so explicitly in the
prompt:

```bash
aristotle submit "Validate deferred and full-paper material in this repository. Review OnePostulate/ClassificationDerivation.lean and OnePostulateFull.lean separately from the phase-1 root. Do not import ClassificationDerivation into OnePostulate.lean." --project-dir . --wait
```

## Formalize Paper Text

To formalize the paper source:

```bash
aristotle formalize paper/one-postulate.tex --wait --destination formalized-paper.tar.gz
```

If you want the formalization to stay aligned with the current repo, include the
project as context in a second step by submitting from the repo root after you
review the generated material.

## Prompt-Only Mode

For isolated experiments:

```bash
aristotle submit "Prove that there are infinitely many primes." --wait
```

Use prompt-only mode for exploration, not for repo validation.

## List, Inspect, And Cancel Projects

List recent projects:

```bash
aristotle list
```

Inspect a result:

```bash
aristotle result <PROJECT_ID>
```

Cancel a running project:

```bash
aristotle cancel <PROJECT_ID>
```

## Interpret Project Statuses

Use `aristotle list` and `aristotle result <PROJECT_ID>` to interpret where a
job stands:

- `QUEUED`: accepted but not started yet
- `IN_PROGRESS`: actively running
- `COMPLETE`: finished successfully and ready for review
- `COMPLETE_WITH_ERRORS`: finished, but some files or targets still need review
- `OUT_OF_BUDGET`: stopped before finishing; resume with a narrower follow-up run
- `FAILED`: request or backend failure; inspect the result payload before retrying
- `CANCELED`: stopped intentionally

For this repository, `COMPLETE` is still only a candidate result. You must still
review theorem statements, imports, and the phase-1 proof surface locally.

## Download And Review Results

Use the result command to retrieve the latest output for a project:

```bash
aristotle result <PROJECT_ID>
```

If your installed CLI supports an explicit destination flag, store the bundle
outside the tracked repo:

```bash
mkdir -p results
aristotle result <PROJECT_ID> --destination results/<PROJECT_ID>.tar.gz
```

If your installed CLI exposes an explicit output or destination flag, use it to
store the result bundle outside the tracked repo and review it before copying
anything back into the workspace.

## Resume Or Narrow Out-Of-Budget Runs

First inspect the old run:

```bash
aristotle list
aristotle result <PROJECT_ID>
```

Then resume operationally by submitting a narrower follow-up job:

```bash
aristotle submit "Continue validating this repository, but scope the work to OnePostulate/ClassificationDerivation.lean and OnePostulateFull.lean only. Preserve theorem statements and imports." --project-dir . --wait
```

For hole-filling or repair, narrow to one file or one theorem instead of
resubmitting the whole repo.

## `--wait` Versus Manual Polling

Use `--wait` when:

- the job is small
- you are iterating locally
- you want the result in the current shell session

Use manual polling when:

- the job is large
- you are formalizing paper text
- you expect budget exhaustion or multiple retries

Manual polling flow:

```bash
aristotle submit "Validate the Lean project in this repository." --project-dir .
aristotle list
aristotle result <PROJECT_ID>
```

## Practical Notes For This Repo

- Aristotle can use Lean files, Markdown notes, and paper text under `--project-dir .`.
- It resolves imports automatically and skips build artifacts.
- This repo’s main paper artifact is `paper/one-postulate.tex`.
- The highest-value Lean targets are:
  - `OnePostulate.lean`
  - `OnePostulate/ClassificationDerivation.lean`
  - `OnePostulateFull.lean`

## See Also

- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)
- [Python API workflows](PYTHON_API_WORKFLOWS.md)
