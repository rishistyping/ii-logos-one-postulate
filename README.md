# One Postulate Lean

`one-postulate-lean` is a Lean 4 + Mathlib formalization repository for the
One Postulate project. It contains the Lean project, the paper source, the
blueprint theorem ledger, and a Gauss project manifest so the repository can be
used directly with an external OpenGauss installation.

This repository does **not** ship the OpenGauss runtime itself. The supported
workflow is:

1. build and validate the Lean repository with Lake
2. use a globally installed `gauss` against this repository root

## Repository Contents

- `OnePostulate/` — main formalization modules
- `OnePostulate.lean` — phase-1 root import surface
- `OnePostulateFull.lean` — full-paper mathematical root import surface
- `docs/aristotle/` — repo-specific Aristotle validation, repair, and review docs
- `GaussProofSandbox/` — preserved smoke-test scaffold
- `GaussProofSandbox.lean` — preserved smoke-test root module
- `Main.lean` — preserved executable entry
- `paper/` — editable paper source and rendered PDF
- `blueprint/src/content.tex` — dependency-ordered theorem ledger
- `.gauss/project.yaml` — OpenGauss project manifest for this repository
- `lakefile.toml`, `lake-manifest.json`, `lean-toolchain` — Lean/Lake project configuration

## Prerequisites

### Lean / Lake

- `elan` installed
- Lean toolchain from `lean-toolchain`
- `lake` available on `PATH`

### Mathlib cache

The first build should populate dependencies and fetch the Mathlib build cache:

```bash
lake update
lake exe cache get
```

### OpenGauss

To use managed `/draft`, `/prove`, `/formalize`, or `/autoformalize` workflows,
you need a globally installed and authenticated `gauss`:

- `gauss` available on `PATH`
- Codex/OpenGauss auth already working
- `codex` available if you plan to use the Codex backend

## Lean Build Steps

Run these from the repository root:

```bash
lake update
lake exe cache get
lake build
```

Optional targeted builds:

```bash
lake build OnePostulate
lake build gauss-proof-sandbox
```

Root surfaces:

- `OnePostulate.lean` is the phase-1 root and must remain free of `OnePostulate.ClassificationDerivation`.
- `OnePostulateFull.lean` is the full-paper mathematical root and imports the phase-1 surface plus `OnePostulate.ClassificationDerivation`.

## Lean Test and Validation

Primary validation:

```bash
lake build
```

Optional targeted checks:

```bash
lake build OnePostulate
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
```

Expected result:

- `lake build` completes successfully
- `OnePostulateFull.lean` typechecks as the full-paper entrypoint
- `OnePostulate/ClassificationDerivation.lean` typechecks while remaining unimported

## Aristotle Docs

Repo-specific Aristotle documentation lives under `docs/aristotle/`.

- Start with [docs/aristotle/README.md](docs/aristotle/README.md).
- Use those docs for Aristotle-based validation, repair, hardening, and
  paper-to-Lean checking in this repository.
- The Aristotle docs also explain how to use Aristotle without widening the
  phase-1 proof surface rooted at `OnePostulate.lean`.

## Using OpenGauss With This Repository

The supported setup is an external/global OpenGauss installation pointed at
this repo.

From the repository root:

```bash
gauss
```

At the `gauss>` prompt:

```text
/project status
/autoformalize-backend codex
```

If ambient project detection is not already active, run:

```text
/project use .
```

### Example `/draft`

```text
/draft
In ClassificationDerivation.lean, replace the deferred placeholder with the next dependency-ordered derivation statements, keep the file unimported, preserve the matrix-first style, and keep lake build green.
```

### Example `/prove`

```text
/prove
In Selection.lean, strengthen the final positive/zero/negative branch summary using the current explicit matrix statements only, and keep unrelated declarations unchanged.
```

## Expected OpenGauss Checks

When `gauss` is started from this repository root, the following should hold:

- the TUI banner shows the repository path
- the banner or status area shows `Project: one-postulate-lean · blueprint`
- `/project status` reports:
  - root = this repository
  - manifest = `.gauss/project.yaml`
  - source mode = `init`
- `/autoformalize-backend codex` is accepted

## Workflow Note

This repository is a Lean/formalization workspace. It is not the OpenGauss
runtime repository. Build and test the Lean project locally with Lake, and use
an external/global `gauss` installation for managed workflow commands.

## Clone

```bash
git clone https://github.com/rishistyping/one-postulate-lean.git
cd one-postulate-lean
```
