# One Postulate Lean

`one-postulate-lean` is a Lean 4 + Mathlib formalization of the mathematical
argument developed in *One Postulate*. The repository brings together the
current paper source, a matrix-first Lean development, a dependency-ordered
blueprint ledger, and validation workflows that check the Lean statements
against the paper.

The project starts from a familiar question in the foundations of relativity:
what follows if one takes the relativity principle seriously and asks what kind
of kinematics it permits before assuming a fixed invariant speed? The paper's
answer is that this principle determines a one-parameter family of kinematic
algebras, and that the algebra's own canonical invariant, the Killing form,
separates that family into three qualitatively different branches. The Lean
formalization tracks that argument directly, using explicit matrices and
concrete calculations rather than hiding the geometry behind abstract
machinery.

## Narrative project summary

This repository is both a paper workspace and a formalization workspace. The
paper in `paper/one-postulate.tex` gives the mathematical narrative: rotations
and boosts satisfy a one-parameter commutator law, the resulting algebra has a
Killing form with a rigid diagonal shape, and that form determines whether the
resulting spacetime geometry is Euclidean, Galilean, or Lorentzian. The Lean
code mirrors that story step by step. It starts from explicit spacetime and
adjoint matrices, proves the bracket table, computes the Killing form,
analyzes invariant forms on velocity space and spacetime, and packages the
three-way branch split into reusable summary theorems.

As a result, the repository is not just a collection of isolated Lean lemmas.
It is a structured formal account of the paper's central claim: the existence
of a finite invariant speed is not an extra axiom laid on top of relativity,
but a consequence of the algebraic branch selected by the sign of `κ`.

## What the paper shows

The paper begins with the relativity principle and the most general isotropic
kinematic Lie algebra compatible with rotations and boosts. That produces a
one-parameter family `\mathfrak{h}_\kappa`, where the parameter `κ` controls
the boost-boost commutator. From there, the decisive object is the Killing
form. Its diagonal structure records how the algebra "sees" rotations and
boosts, and that information determines what kind of invariant geometry can
exist.

When `κ < 0`, the invariant form is definite on the relevant spacetime data,
there is no lightcone structure, and no nontrivial causal ordering emerges.
When `κ = 0`, the Killing form becomes blind to boosts, leaving only a
conformal shape on velocity space and collapsing the spacetime metric to the
absolute-time direction `dt²`; the representation becomes reducible and one is
forced into Galilean structure. When `κ > 0`, the algebra fixes a Lorentzian
metric, determines a finite real invariant speed, and yields the relativistic
branch without requiring an independent postulate for that speed.

In short, the paper's three outcomes are:

- `κ < 0`: Euclidean branch, no lightcone, no causal structure
- `κ = 0`: Galilean branch, degenerate boost-sector structure, invariant `dt²`, and reducible spacetime representation
- `κ > 0`: Lorentz branch, nondegenerate invariant metric, and finite real invariant speed

## How the Lean formalization tracks the paper

The Lean development follows the paper in the same order that a careful human
reader would reconstruct the argument. It starts with explicit `4 x 4`
spacetime generators for rotations and boosts, then lifts those calculations to
the six-dimensional kinematic algebra. From there it computes the adjoint
representation, derives the diagonal Killing form, and uses that computation to
study which invariant symmetric forms can exist on the boost sector and on the
full spacetime representation.

This is a deliberately matrix-first formalization. Instead of beginning from
high-level classification theorems and working backward, the repository proves
the paper's claims through concrete matrix formulas, commutator identities,
trace calculations, and explicit invariant-form arguments. The blueprint ledger
in `blueprint/src/content.tex` records this dependency order, so the paper, the
Lean code, and the theorem ledger all tell the same story from different
angles.

That design matters for readability and for validation. It makes it possible to
check the formalization against the paper claim by claim: the bracket table,
the Killing form, the boost-space metric story, the spacetime metric story, the
zero-`κ` invariant-time and reducibility story, and the final branch-selection
results are all exposed as concrete outcomes of the development.

## Main mathematical outcomes

The current repository proves the core mathematical claims of the paper's main
argument and its stronger full-paper packaging.

- The homogeneous bracket table for rotations and boosts is derived explicitly.
- The Killing form is computed explicitly as a diagonal form with rotation and
  boost blocks of different sign behavior.
- The boost sector is shown to support a unique invariant symmetric form up to
  scale, with the zero-`κ` case degenerating to a conformal-only situation.
- The invariant spacetime metric is identified in diagonal form as
  `diag(1, -κ, -κ, -κ)`.
- The `κ = 0` branch is shown to preserve an absolute-time direction and to
  produce a reducible spacetime representation.
- The `κ > 0` branch is shown to yield Lorentzian structure and a finite real
  invariant speed.
- The stronger full-paper surface packages these results into the full
  classification bridge without widening the main imported root.

## Formalization structure

The main formalization lives under `OnePostulate/` and proceeds in dependency
order.

- `OnePostulate/SpacetimeMatrices.lean` defines the explicit spacetime
  generators and concrete matrix objects.
- `OnePostulate/KinematicAlgebra.lean` builds the six-dimensional algebra and
  proves the bracket table.
- `OnePostulate/KillingForm.lean` computes the adjoint trace form and connects
  it to Mathlib's abstract Killing form.
- `OnePostulate/VelocitySpace.lean` analyzes invariant forms on the boost
  sector.
- `OnePostulate/SpacetimeRepresentation.lean` studies the spacetime metric,
  invariant covectors, reducibility, and Lorentzian normal form.
- `OnePostulate/Selection.lean` packages the branch-selection consequences.
- `OnePostulate/ClassificationDerivation.lean` provides the
  supplemental/full-paper classification bridge.

The dependency-ordered theorem ledger in `blueprint/src/content.tex` mirrors
that progression.

## Roots and proof-surface boundaries

The repository deliberately separates its root surfaces.

- `OnePostulate.lean` is the main imported root.
- `OnePostulateFull.lean` is the full-paper root.
- `OnePostulate.ClassificationDerivation` remains outside
  `OnePostulate.lean` and is validated separately.

That boundary is a real repository invariant, not just a documentation choice.
The main root is kept narrow so that the core formal surface remains stable and
reviewable, while the stronger full-paper bridge can be checked on its own
terms.

## Current validation state

The current repository state is validated both locally and through archived
Aristotle runs against the current paper source.

Locally:

- `lake build` is green for the main Lean project.
- `OnePostulate/ClassificationDerivation.lean` typechecks separately.
- `OnePostulateFull.lean` typechecks separately.
- CI guards reject `sorry|admit` in the guarded `OnePostulate` surface.
- CI guards reject importing `OnePostulate.ClassificationDerivation` into
  `OnePostulate.lean`.

Against the current paper:

- archived main-surface Aristotle run
  [`483c60fc-d712-4426-b086-30bf99699fa2`](docs/aristotle/runs/483c60fc-d712-4426-b086-30bf99699fa2/README.md)
  validated `OnePostulate.lean`,
  `OnePostulate/SpacetimeRepresentation.lean`, and
  `OnePostulate/Selection.lean` against the current `paper/one-postulate.tex`
  and reported no mismatches, no theorem or import changes, preserved
  boundaries, and only cosmetic warnings
- archived full-paper Aristotle run
  [`e6639ca2-b91a-4b73-aa99-780e921628ab`](docs/aristotle/runs/e6639ca2-b91a-4b73-aa99-780e921628ab/README.md)
  validated `OnePostulateFull.lean` and
  `OnePostulate/ClassificationDerivation.lean` against the current
  `paper/one-postulate.tex` and likewise reported no mismatches, no theorem or
  import changes, preserved boundaries, and only cosmetic warnings

In practical terms, the repository currently exposes `OnePostulate.lean` as the
main imported root and `OnePostulateFull.lean` as the stronger full-paper
entrypoint, with both surfaces already checked against the current paper.

## Repository contents

- `OnePostulate/` — main formalization modules
- `OnePostulate.lean` — main imported root
- `OnePostulateFull.lean` — full-paper root
- `docs/aristotle/` — repository-specific Aristotle validation and review docs
- `GaussProofSandbox/` — preserved smoke-test scaffold
- `GaussProofSandbox.lean` — preserved smoke-test root module
- `Main.lean` — preserved executable entry
- `paper/` — paper source and rendered PDF
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

- [documentation.md](documentation.md) — detailed technical repository map and
  theorem surface
- [docs/aristotle/README.md](docs/aristotle/README.md) — Aristotle-based
  validation, repair, hardening, and paper-to-Lean review
- `paper/one-postulate.tex` — current editable paper source
- `blueprint/src/content.tex` — dependency-ordered theorem ledger

## Using OpenGauss with this repository

OpenGauss is the project-scoped Lean workflow orchestrator used with this
repository. In practice, it gives `gauss` a managed frontend for proving and
formalization workflows while leaving this repository itself as the source of
truth for Lean code, paper text, and project metadata.

This repository does **not** ship the OpenGauss runtime itself. The supported
pattern is to validate the Lean project locally and then point a globally
installed `gauss` client at this repository root.

The OpenGauss workflow family supported here includes:

- `/prove`
- `/draft`
- `/autoprove`
- `/formalize`
- `/autoformalize`

For upstream installation and broader workflow documentation, see the
[math-inc/OpenGauss README](https://github.com/math-inc/OpenGauss).

A typical repository-local flow is:

```bash
gauss
```

Then in the Gauss interface:

```text
/project use .
/project status
```

Typical next steps are:

```text
/autoformalize-backend codex
/prove
/formalize
```

Within this repository, OpenGauss is best used as an orchestrator around the
existing formal surface rather than as a replacement for local Lean validation.
The core loop is:

1. validate the repository locally with Lake
2. target this repository root from `gauss`
3. use `gauss` workflows to draft, prove, or formalize against the existing
   Lean surface
4. rerun local Lean checks before accepting any resulting change

For this project specifically, OpenGauss should respect the same surface
boundaries as the rest of the toolchain: `OnePostulate.lean` remains the main
root, while `OnePostulateFull.lean` and
`OnePostulate/ClassificationDerivation.lean` cover the stronger full-paper
surface.

## Aristotle docs

Repository-specific Aristotle guidance lives under `docs/aristotle/`.

- Start with [docs/aristotle/README.md](docs/aristotle/README.md).
- Use those docs for Aristotle-based validation, repair, hardening, and
  paper-to-Lean checking in this repository.
- The Aristotle docs explain how to validate or review the repository without
  widening the current proof-surface boundary rooted at `OnePostulate.lean`.
