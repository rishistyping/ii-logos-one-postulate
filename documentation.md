# one-postulate-lean Repository Documentation

This file is a retrieval-oriented context pack for developers and ML systems
working on `one-postulate-lean`.

Treat source files as the final authority. Use this document as the quick map.

## Identity

- Repository name: `one-postulate-lean`
- Lean package name: `gauss-proof-sandbox`
- Lean libraries:
  - `GaussProofSandbox`
  - `OnePostulate`
- Executable target: `gauss-proof-sandbox`
- Primary purpose: Lean 4 + Mathlib formalization of the One Postulate project
- External workflow tool: global `gauss` installation using `.gauss/project.yaml`

## Repository Baseline

This repository baseline includes:

- the Lean formalization under `OnePostulate/`
- the Aristotle docs under `docs/aristotle/`
- the preserved smoke-test scaffold under `GaussProofSandbox/`
- the paper source in `paper/one-postulate.tex`
- the blueprint theorem ledger in `blueprint/src/content.tex`
- the Gauss project manifest in `.gauss/project.yaml`

This repository does **not** contain the OpenGauss Python runtime or gateway
code. It is meant to be operated as a Lean repository that can be targeted by
an external/global `gauss` installation.

## Main Lean Surface

Top-level project files:

- `lakefile.toml`
- `lake-manifest.json`
- `lean-toolchain`
- `Main.lean`
- `OnePostulate.lean`
- `OnePostulateFull.lean`
- `GaussProofSandbox.lean`
- `docs/aristotle/README.md`

Primary formalization modules:

- `OnePostulate/Basic.lean`
- `OnePostulate/SpacetimeMatrices.lean`
- `OnePostulate/KinematicAlgebra.lean`
- `OnePostulate/KillingForm.lean`
- `OnePostulate/VelocitySpace.lean`
- `OnePostulate/SpacetimeRepresentation.lean`
- `OnePostulate/Selection.lean`
- `OnePostulate/ClassificationDerivation.lean`

Important invariant:

- `OnePostulate/ClassificationDerivation.lean` exists but remains unimported in `OnePostulate.lean`
- `OnePostulateFull.lean` is the separate full-paper root that imports `OnePostulate` and `OnePostulate.ClassificationDerivation`
- `docs/aristotle/README.md` explains how to use Aristotle for validation,
  repair, hardening, and paper alignment without widening the phase-1 proof
  surface

## Mathematical Baseline

The current phase-1 development is matrix-first:

- explicit `4 x 4` spacetime generators
- explicit `6 x 6` adjoint matrices and trace-based Killing-form calculations
- explicit `3 x 3` boost-space commutant calculations
- explicit `κ = 0` invariant time-line structure
- explicit Lorentz congruence for `κ > 0`
- explicit phase-1 selection split in `OnePostulate/Selection.lean`

Paper and blueprint artifacts:

- editable source: `paper/one-postulate.tex`
- rendered artifact: `paper/one-postulate.pdf`
- theorem ledger: `blueprint/src/content.tex`

## OnePostulate Phase-1 Theorem Map

- Bracket table: `OnePostulate.kinematic_bracket_table`
  Maps the paper's homogeneous commutator table for `J_i` and `K_i`.
- Jacobi: `OnePostulate.kinematic_bracket_jacobi`
  Packages the Jacobi identity for the six-dimensional phase-1 kinematic algebra.
- Killing form: `OnePostulate.killing_form_diag`, `OnePostulate.boost_killing_form_eq`, `OnePostulate.boost_killing_nondegenerate_iff_kappa_ne_zero`
  Covers the explicit diagonal Killing-form computation and the boost-sector nondegeneracy split by `κ`.
- Zero-branch conformal-only surface: `OnePostulate.boost_invariant_form_scalar`, `OnePostulate.killing_restricts_to_metric`, `OnePostulate.velocityMetricMatrix_at_zero`
  This is the current phase-1 Lean surface for the paper's conformal-only claim at `κ = 0`; it is represented by this combination of lemmas rather than a stronger dedicated theorem.
- Spacetime metric invariance: `OnePostulate.spacetime_metric_invariant`
  Formalizes invariance of the explicit spacetime metric under the matrix generators.
- Positive-branch Lorentz congruence: `OnePostulate.spacetime_metric_congruent_stdLorentz_of_kappa_pos`
  Gives the explicit congruence to standard Lorentz signature when `κ > 0`.
- Zero-branch reducibility: `OnePostulate.reducible_of_kappa_zero`, `OnePostulate.spacetime_metric_degenerate_of_kappa_zero`
  Captures the invariant time line and metric degeneracy at `κ = 0`.
- Final `κ < 0 / κ = 0 / κ > 0` trichotomy: `OnePostulate.phase1_selection_summary`
  Packages the phase-1 branch consequences for the Euclidean, Galilean, and Lorentzian cases.
- Full-paper entrypoint: `OnePostulateFull.lean`
  Imports the phase-1 root plus the classification bridge for the stronger paper-complete surface.

## Build and Validation

Run from the repository root:

```bash
lake update
lake exe cache get
lake build
```

Optional targeted validation:

```bash
lake build OnePostulate
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
```

## Using External OpenGauss

This repository is configured for project-scoped OpenGauss use via:

- `.gauss/project.yaml`

Expected external workflow:

```bash
gauss
```

Then:

```text
/project status
/autoformalize-backend codex
```

If ambient detection is not already active:

```text
/project use .
```

Expected project facts in the Gauss TUI:

- project label: `one-postulate-lean`
- blueprint markers: `lean-toolchain`, `lakefile.toml`
- root and lean root both resolve to this repository root

## Recommended Navigation

If the task is about:

- algebraic foundations -> `OnePostulate/Basic.lean`
- explicit spacetime generators -> `OnePostulate/SpacetimeMatrices.lean`
- Lie algebra surface -> `OnePostulate/KinematicAlgebra.lean`
- Killing-form computation -> `OnePostulate/KillingForm.lean`
- boost-space metric arguments -> `OnePostulate/VelocitySpace.lean`
- spacetime metric and reducibility -> `OnePostulate/SpacetimeRepresentation.lean`
- branch selection theorems -> `OnePostulate/Selection.lean`
- deferred derivation layer -> `OnePostulate/ClassificationDerivation.lean`
- Aristotle-assisted validation, repair, paper alignment, and review -> `docs/aristotle/README.md`
- paper text -> `paper/one-postulate.tex`
- theorem dependency ledger -> `blueprint/src/content.tex`

## Aristotle Docs

The repo-specific Aristotle guide lives under `docs/aristotle/`. It explains
how to use Aristotle to validate Lean outputs, compare Lean statements against
the paper, search for counterexamples, and review deferred or full-paper work
without widening the phase-1 proof surface.
- Aristotle validation, repair, hardening, or paper-to-Lean workflow -> `docs/aristotle/README.md`
- Archived full-paper Aristotle validation run `eaa48588-a529-405f-a871-13665c6b85c5` -> `docs/aristotle/runs/eaa48588-a529-405f-a871-13665c6b85c5/README.md`

## Retrieval Keywords

- one-postulate-lean
- OnePostulate
- GaussProofSandbox
- gauss-proof-sandbox
- Lean 4
- Mathlib
- Killing form
- kinematic algebra
- Lorentz branch
- Galilean branch
- Euclidean branch
- invariant speed
- matrix-first formalization
