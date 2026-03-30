# One Postulate Lean

`one-postulate-lean` is a Lean 4 + Mathlib formalization of the argument in *One Postulate*: starting from the relativity principle and a one-parameter kinematic family indexed by `κ`, the repository derives the homogeneous bracket structure, computes the Killing form, and separates the Euclidean, Galilean, and Lorentzian branches in a matrix-first proof development. The paper in [`paper/one-postulate.tex`](paper/one-postulate.tex) states the narrative, Lean supplies the proof authority, and the symbolic notebook surfaces provide computational intuition.

## At a Glance

- The formal development is organized around `κ`, which controls the boost-boost commutator and therefore the kinematic branch.
- The Lean spine starts with explicit matrices, proves the bracket table, computes the Killing form, and only then reads off metric consequences.
- The decisive invariant is the Killing form:
  `diag(-4 I_3, 4 κ I_3)` in the ordered `(Jx, Jy, Jz, Kx, Ky, Kz)` basis.
- The three branches are formalized explicitly:
  - `κ < 0`: Euclidean branch, no nonzero null vectors
  - `κ = 0`: Galilean branch, degenerate boost sector, invariant absolute-time direction
  - `κ > 0`: Lorentzian branch, nondegenerate invariant metric, finite real invariant speed
- The guarded root is [`OnePostulate.lean`](OnePostulate.lean); the full-paper root is [`OnePostulateFull.lean`](OnePostulateFull.lean).

## Visual Proof Map

```mermaid
flowchart LR
    A["SpacetimeMatrices"] --> B["KinematicAlgebra"]
    B --> C["KillingForm"]
    C --> D["VelocitySpace"]
    C --> E["SpacetimeRepresentation"]
    D --> F["Selection"]
    E --> F
    F --> G["ClassificationDerivation"]
```

```mermaid
flowchart TD
    A["matrix_bracket_JJ / matrix_bracket_JK / matrix_bracket_KK"] --> B["kinematic_bracket_table"]
    B --> C["killing_form_diag"]
    C --> D["boost_killing_form_eq"]
    D --> E["killing_restricts_to_metric"]
    D --> F["spacetime_metric_invariant"]
    E --> G["zero_kappa_velocity_metric_only_conformal"]
    F --> H["reducible_of_kappa_zero"]
    F --> I["spacetime_metric_congruent_stdLorentz_of_kappa_pos"]
    G --> J["phase1_selection_summary"]
    H --> J
    I --> J
```

```mermaid
flowchart LR
    K["kappa"] --> N["kappa < 0<br/>Euclidean"]
    K --> Z["kappa = 0<br/>Galilean"]
    K --> P["kappa > 0<br/>Lorentzian"]
```

## Why the Killing Form Matters

```mermaid
flowchart LR
    A["Relativity principle<br/>one-parameter kinematic family"] --> B["Bracket structure<br/>adjoint setup"]
    B --> C["Killing form computation"]
    C --> D["Boost-sector and spacetime consequences<br/>geometry is read off here, not assumed first"]
    D --> E["Three kappa branches<br/>Euclidean / Galilean / Lorentzian"]
```

The argument does not assume the final spacetime metric first and then check it later. It computes the algebra's canonical invariant, shows how the boost block scales with `κ`, and then reads geometry from that result. A fuller walkthrough lives in [docs/proof-visuals.md](docs/proof-visuals.md).

## Paper <-> Lean <-> Notebook

```mermaid
flowchart TB
    subgraph S1["Bracket setup"]
        direction LR
        P1["Paper<br/>The postulate / What the postulate determines"]
        L1["Lean<br/>SpacetimeMatrices + KinematicAlgebra<br/>matrix_bracket_* / kinematic_bracket_table"]
        N1["Notebook<br/>Transformation law, Galilean limit, adopted algebra"]
        P1 --> L1 --> N1
    end
    subgraph S2["Killing form"]
        direction LR
        P2["Paper<br/>Can the rules examine themselves?"]
        L2["Lean<br/>KillingForm + VelocitySpace<br/>killing_form_diag / boost_killing_form_eq / killing_restricts_to_metric"]
        N2["Notebook<br/>Adjoint action, Killing form, kappa = 0 collapse"]
        P2 --> L2 --> N2
    end
    subgraph S3["Branch classification"]
        direction LR
        P3["Paper<br/>Three verdicts / Structure and scale"]
        L3["Lean<br/>SpacetimeRepresentation + Selection + ClassificationDerivation<br/>phase1_selection_summary / classification_derivation_complete_full"]
        N3["Notebook<br/>Regime table and branch comparison"]
        P3 --> L3 --> N3
    end
    S1 --> S2 --> S3
```

| Paper idea | Lean proof surface | Computational companion |
| --- | --- | --- |
| `The postulate` / `What the postulate determines` | [`OnePostulate/SpacetimeMatrices.lean`](OnePostulate/SpacetimeMatrices.lean), [`OnePostulate/KinematicAlgebra.lean`](OnePostulate/KinematicAlgebra.lean), `matrix_bracket_*`, `kinematic_bracket_table` | [`one_postulate_sympy_colab.ipynb`](one_postulate_sympy_colab.ipynb) opening sections on the `1+1` law, Galilean limit, and adopted algebra |
| `Can the rules examine themselves?` | [`OnePostulate/KillingForm.lean`](OnePostulate/KillingForm.lean), [`OnePostulate/VelocitySpace.lean`](OnePostulate/VelocitySpace.lean), `killing_form_diag`, `boost_killing_form_eq`, `killing_restricts_to_metric` | SymPy notebook middle sections on adjoint action, Killing form, and the `κ = 0` collapse |
| `Three verdicts` / `Structure and scale` | [`OnePostulate/SpacetimeRepresentation.lean`](OnePostulate/SpacetimeRepresentation.lean), [`OnePostulate/Selection.lean`](OnePostulate/Selection.lean), [`OnePostulate/ClassificationDerivation.lean`](OnePostulate/ClassificationDerivation.lean) | notebook regime table and branch comparison cells |

For the deeper walkthrough, see [docs/proof-visuals.md](docs/proof-visuals.md), the notebook guide in [docs/notebooks.md](docs/notebooks.md), and the notebook itself in [`one_postulate_sympy_colab.ipynb`](one_postulate_sympy_colab.ipynb).

## Formalization and Validation Story

This repository is not only a Lean formalization of the paper. It is also set up to be checked by external autoformalization and theorem-proving tooling. The core proof remains the local Lean code, but the surrounding validation story is now part of the public record.

- Lean formalization:
  the repository formalizes the matrix-first spine of the paper, from the bracket table and Killing form through the `κ < 0`, `κ = 0`, and `κ > 0` branch split.
- Aristotle by Harmonic:
  the external prover is documented in the repository as a second prover and checker, and Harmonic describes Aristotle as a system that combines formal verification with informal reasoning in Lean ([arXiv](https://arxiv.org/abs/2510.01346), [Harmonic PDF](https://harmonic.fun/pdf/Aristotle_IMO_Level_Automated_Theorem_Proving.pdf)).
- OpenGauss / Gauss by Math, Inc.:
  the repository includes project-scoped Gauss configuration in [`.gauss/project.yaml`](.gauss/project.yaml), and Math, Inc. describes OpenGauss as an open-source, state-of-the-art autoformalization harness for Lean and Gauss as its frontier autoformalization agent ([OpenGauss](https://www.math.inc/opengauss), [Gauss](https://www.math.inc/gauss)).

### What The Formalization Covers

- Main imported surface:
  explicit generators, `matrix_bracket_*`, `kinematic_bracket_table`, the explicit Killing form, the boost-sector metric, the invariant spacetime form, and the phase-1 branch split.
- Full-paper surface:
  the deferred classification bridge in [`OnePostulate/ClassificationDerivation.lean`](OnePostulate/ClassificationDerivation.lean), kept separate from the guarded root [`OnePostulate.lean`](OnePostulate.lean).
- Public branch summary:
  `κ < 0` gives the Euclidean branch, `κ = 0` the Galilean branch, and `κ > 0` the Lorentzian branch with a finite real invariant speed.

### What The Verification Summaries Say

- Main-surface Aristotle validation:
  the archived run in [docs/aristotle/runs/483c60fc-d712-4426-b086-30bf99699fa2/ARISTOTLE_SUMMARY_483c60fc-d712-4426-b086-30bf99699fa2.md](docs/aristotle/runs/483c60fc-d712-4426-b086-30bf99699fa2/ARISTOTLE_SUMMARY_483c60fc-d712-4426-b086-30bf99699fa2.md) reports a clean main-surface build, no `sorry`s, standard axioms only, and no mismatches against [`paper/one-postulate.tex`](paper/one-postulate.tex).
- Full-paper Aristotle validation:
  the archived run in [docs/aristotle/runs/e6639ca2-b91a-4b73-aa99-780e921628ab/ARISTOTLE_SUMMARY_e6639ca2-b91a-4b73-aa99-780e921628ab.md](docs/aristotle/runs/e6639ca2-b91a-4b73-aa99-780e921628ab/ARISTOTLE_SUMMARY_e6639ca2-b91a-4b73-aa99-780e921628ab.md) reports no mismatches for [`OnePostulateFull.lean`](OnePostulateFull.lean) and [`OnePostulate/ClassificationDerivation.lean`](OnePostulate/ClassificationDerivation.lean), with the main import boundary preserved.
- OpenGauss status in this repository:
  the repository is configured for project-scoped OpenGauss use and interactive autoformalization workflows, but the tracked validation archive in this checkout is Aristotle-centered rather than a committed OpenGauss run report.

## How to Read This Repo

- General audience:
  start with [`paper/one-postulate.pdf`](paper/one-postulate.pdf), skim the diagrams above, then open [docs/notebooks.md](docs/notebooks.md) for the computational companions.
- Math reader:
  read [`paper/one-postulate.tex`](paper/one-postulate.tex), then [docs/proof-visuals.md](docs/proof-visuals.md), then the dependency ledger in [`blueprint/src/content.tex`](blueprint/src/content.tex).
- Lean reader:
  begin at [`OnePostulate.lean`](OnePostulate.lean), follow the module order shown in the proof map, and use [`OnePostulateFull.lean`](OnePostulateFull.lean) only when you want the deferred classification bridge.

## Build and Validation

```bash
lake build
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
rg -n 'sorry|admit' OnePostulateFull.lean OnePostulate.lean OnePostulate/*.lean
```

For repository-specific workflow notes and archived review runs, see [docs/aristotle/README.md](docs/aristotle/README.md). For project-scoped Gauss/OpenGauss setup, see [documentation.md](documentation.md).

## Repo Status

- Proof authority lives in the local paper and Lean files, not in the README or notebooks.
- The guarded import boundary is preserved:
  [`OnePostulate.lean`](OnePostulate.lean) does not import `OnePostulate.ClassificationDerivation`.
- The full-paper bridge remains separate in [`OnePostulateFull.lean`](OnePostulateFull.lean).
- Public-facing visuals and notebooks are intended to make the argument easier to read, not to widen the formal surface.
- External validation story:
  Aristotle run summaries are archived in-tree; OpenGauss is configured in-tree, but this checkout does not currently archive a dedicated OpenGauss validation report.

## Completed TODO Checklist

- [x] 2026-03-30 `91880ef`: Fix Mermaid labels so GitHub renders the proof diagrams correctly. Current branch only.
- [x] 2026-03-30 `fae4848`: Refresh the public docs and notebook surfaces, including the landing-page README, proof visuals, notebook guide, Wolfram companion notebook, and preview assets. Current branch only.
- [x] 2026-03-29 `46309e7`: Archive Aristotle validation bundles as tracked tarballs. Present only on `origin/aristotle-one-postulate`.
- [x] 2026-03-29 `04b2de7` / `9b8d8b8`: Add a paper-aligned narrative to the SymPy notebook. Shared across the SymPy, Aristotle, and current branch lines.
- [x] 2026-03-28 `3d819f2`: Rewrite the README as a narrative overview. Shared across the docs-oriented branch lines.
- [x] 2026-03-28 `11d7901`: Update the paper and archive the current Aristotle validation runs.
- [x] 2026-03-28 `ca63e19`: Archive the Aristotle main-surface validation run.
- [x] 2026-03-27 `33b22f1`: Archive the Aristotle full-paper validation run.
- [x] 2026-03-27 `a872df5`: Improve the README documentation.
- [x] 2026-03-27 `7e604b9`: Add repository-specific Aristotle documentation.
- [x] 2026-03-27 `176dd3e`: Add the full-paper `OnePostulateFull` surface and the deferred classification bridge.
- [x] 2026-03-27 `7c22460`: Close out the phase-1 branch guards and validation hardening docs.
- [x] 2026-03-26 `b67c260`: Complete the phase-1 formal fixes.
- [x] 2026-03-26 `5c83dca`: Repair the phase-1 Lean surface baseline.
