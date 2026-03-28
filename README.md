# One Postulate Lean

`one-postulate-lean` is a Lean 4 + Mathlib formalization repository for the
*One Postulate* project. It combines the paper source, a matrix-first Lean
formalization, a dependency-ordered theorem ledger, and project metadata for
external OpenGauss workflows.

This repository does **not** ship the OpenGauss runtime itself. The supported
workflow is:

1. build and validate the Lean repository with Lake
2. use a globally installed `gauss` against this repository root

## What the paper argues

The paper in `paper/one-postulate.tex` argues that Einstein's relativity
principle determines a one-parameter family of kinematic algebras
`\mathfrak{h}_\kappa`, and that the algebra's canonical invariant, the Killing
form, selects the physically acceptable branch.

Its branch picture is:

- `κ < 0`: Euclidean branch, compact boosts, and no causal structure
- `κ = 0`: Galilean branch, degenerate boost-sector Killing form, only a
  conformal class on velocity space, reducible spacetime representation, and
  invariant `dt²`
- `κ > 0`: Lorentz branch, nondegenerate Killing form, Lorentzian spacetime
  metric, and finite real invariant speed

The paper's final claim is that observation calibrates the value of the
invariant speed, but the algebra determines its existence: “Einstein needed one
postulate, not two.”

## What this repository formalizes

The Lean development formalizes that argument using explicit matrix
calculations rather than abstract representation-theoretic machinery. The
current formal surface covers:

- the homogeneous bracket table for rotations and boosts
- the explicit Killing-form computation
- the boost-space metric and conformal-only zero-`κ` story
- the invariant spacetime metric and zero-`κ` reducibility story
- the `κ < 0 / κ = 0 / κ > 0` branch-selection consequences
- a separate full-paper bridge that packages the stronger classification surface

The repository is therefore best read as a paper formalization workspace with a
guarded main Lean root, a separate full-paper root, and supporting paper and
blueprint artifacts.

## Formalization structure

The main formalization lives under `OnePostulate/` and progresses in this
order:

- `OnePostulate/SpacetimeMatrices.lean` — explicit matrix generators and
  spacetime-level objects
- `OnePostulate/KinematicAlgebra.lean` — the six-dimensional kinematic algebra
  and bracket table
- `OnePostulate/KillingForm.lean` — adjoint-matrix and trace-based Killing-form
  computation
- `OnePostulate/VelocitySpace.lean` — boost-subspace metric and conformal
  arguments
- `OnePostulate/SpacetimeRepresentation.lean` — spacetime metric, reducibility,
  invariant covectors, and Lorentzian normal form
- `OnePostulate/Selection.lean` — branch-selection and summary theorems
- `OnePostulate/ClassificationDerivation.lean` — supplemental classification
  bridge kept outside the main imported root

The theorem dependency ledger in `blueprint/src/content.tex` tracks the same
development in dependency order.

## Root surfaces

- `OnePostulate.lean` is the main root import surface and must remain free of
  `OnePostulate.ClassificationDerivation`.
- `OnePostulateFull.lean` is the full-paper mathematical root and imports the
  main surface plus `OnePostulate.ClassificationDerivation`.
- `OnePostulate/ClassificationDerivation.lean` is the supplemental/deferred
  bridge that is validated separately and not imported into `OnePostulate.lean`.

## Current validated outputs

The current repository outputs are:

- a green `lake build` for the main Lean project
- a separately typechecked supplemental classification bridge at
  `OnePostulate/ClassificationDerivation.lean`
- a separately typechecked full-paper root at `OnePostulateFull.lean`
- an archived Aristotle full-paper validation run
  [`e6639ca2-b91a-4b73-aa99-780e921628ab`](docs/aristotle/runs/e6639ca2-b91a-4b73-aa99-780e921628ab/README.md)
  for `OnePostulateFull.lean` and `OnePostulate/ClassificationDerivation.lean`
  against the current `paper/one-postulate.tex` that reported no mismatches,
  preserved theorem statements and imports, preserved the main-root boundary,
  and left only cosmetic warnings
- an archived Aristotle main-surface validation run
  [`483c60fc-d712-4426-b086-30bf99699fa2`](docs/aristotle/runs/483c60fc-d712-4426-b086-30bf99699fa2/README.md)
  for `OnePostulate.lean`, `OnePostulate/SpacetimeRepresentation.lean`, and
  `OnePostulate/Selection.lean` against the current `paper/one-postulate.tex`
  that reported no theorem or import changes, no mismatches against the paper,
  preserved the main-root boundary, and left only cosmetic warnings
- CI guards that reject `sorry|admit` in the guarded OnePostulate surface
- CI guards that reject importing `OnePostulate.ClassificationDerivation` into
  `OnePostulate.lean`

In practical terms, the repo currently exposes:

- `OnePostulate.lean` as the main imported root for the guarded formal surface
- `OnePostulateFull.lean` as the stronger full-paper entrypoint

## Project milestones

The user-facing shape of the repository was built in a few major steps:

- initial Lean import with the paper source, blueprint, and core formalization
  scaffold
- Lean CI added for repository validation
- main-surface formal repairs and completion of the matrix-first core
- import-surface guards tightened so `OnePostulate.lean` stays narrow
- `OnePostulateFull.lean` added as a separate full-paper root
- Aristotle documentation added for repo-specific validation, repair, and
  paper-to-Lean review

## Repository contents

- `OnePostulate/` — main formalization modules
- `OnePostulate.lean` — main root import surface
- `OnePostulateFull.lean` — full-paper mathematical root import surface
- `docs/aristotle/` — repo-specific Aristotle validation, repair, and review
  docs
- `GaussProofSandbox/` — preserved smoke-test scaffold
- `GaussProofSandbox.lean` — preserved smoke-test root module
- `Main.lean` — preserved executable entry
- `paper/` — editable paper source and rendered PDF
- `blueprint/src/content.tex` — dependency-ordered theorem ledger
- `.gauss/project.yaml` — OpenGauss project manifest for this repository
- `lakefile.toml`, `lake-manifest.json`, `lean-toolchain` — Lean/Lake project
  configuration

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

## Build and validation

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

Optional targeted checks:

```bash
lake build OnePostulate
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
```

Expected result:

- `lake build` completes successfully
- `OnePostulateFull.lean` typechecks as the full-paper entrypoint
- `OnePostulate/ClassificationDerivation.lean` typechecks while remaining
  unimported by `OnePostulate.lean`

## Documentation

- [documentation.md](documentation.md) — detailed technical repo map and theorem
  surface
- [docs/aristotle/README.md](docs/aristotle/README.md) — Aristotle-based
  validation, repair, hardening, and paper-to-Lean review
- `paper/one-postulate.tex` — editable paper source
- `blueprint/src/content.tex` — dependency-ordered theorem ledger

## Aristotle docs

Repo-specific Aristotle documentation lives under `docs/aristotle/`.

- Start with [docs/aristotle/README.md](docs/aristotle/README.md).
- Use those docs for Aristotle-based validation, repair, hardening, and
  paper-to-Lean checking in this repository.
- The Aristotle docs also explain how to use Aristotle without widening the
  current proof surface rooted at `OnePostulate.lean`.

## Using OpenGauss with this repository

OpenGauss is the project-scoped Lean workflow orchestrator used with this
repository. In practice, it gives `gauss` a managed frontend for proving and
formalization workflows such as:

- `/prove`
- `/draft`
- `/autoprove`
- `/formalize`
- `/autoformalize`

Those workflows run against the active project root, so the intended setup here
is an external/global OpenGauss installation pointed at this repository.

If `gauss` is not installed yet, use the richer installer and platform guidance
in the upstream [math-inc/OpenGauss README](https://github.com/math-inc/OpenGauss).

### Quick start in this repository

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

### Core loop

The normal OpenGauss loop in this repository is:

1. Start `gauss` from the repository root.
2. Confirm that this repository is the active project with `/project status` or
   `/project use .`.
3. Launch a managed workflow such as `/prove`, `/draft`, `/formalize`, or
   `/autoformalize`.
4. Let OpenGauss spawn the backend child session inside this repository root.
5. Use `/swarm` to inspect or reattach to running workflow agents when needed.

For an already existing Lean project like this one, the important step is
project selection, not project creation.

### What OpenGauss should manage here

For this repository, OpenGauss should operate as a project-scoped workflow
layer over the existing Lean codebase. It should:

- detect this repository as the active Lean workspace
- keep workflow execution inside this repository root
- preserve the existing root split between `OnePostulate.lean` and
  `OnePostulateFull.lean`
- complement local Lake validation rather than replace it

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

### Example `/formalize`

```text
/formalize
Use paper/one-postulate.tex as the source text, keep the result aligned with the current matrix-first Lean development, and do not widen the import surface rooted at OnePostulate.lean.
```

## Expected OpenGauss checks

When `gauss` is started from this repository root, the following should hold:

- the TUI banner shows the repository path
- the banner or status area shows `Project: one-postulate-lean · blueprint`
- `/project status` reports:
  - root = this repository
  - manifest = `.gauss/project.yaml`
  - source mode = `init`
- `/autoformalize-backend codex` is accepted
- managed workflow agents stay attached to this repository as the active
  project
- `/swarm` shows the running workflow sessions when a proof or formalization
  job is active

## Workflow note

This repository is a Lean/formalization workspace. It is not the OpenGauss
runtime repository. Build and test the Lean project locally with Lake, and use
an external/global `gauss` installation for managed workflow commands. The
upstream OpenGauss repository owns installer, platform, and runtime details; this
repository owns the Lean code, paper source, and project-scoped workflow usage.

## Clone

```bash
git clone https://github.com/rishistyping/one-postulate-lean.git
cd one-postulate-lean
```
