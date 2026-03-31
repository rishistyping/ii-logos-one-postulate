# One Postulate Wolfram Notebook Plan

This file freezes the narrative, visual, and artifact contract for the Wolfram
explainer workflow. Implementation should follow this structure exactly unless a
source-truth conflict in the local paper or Lean files requires a correction.

## Canonical Artifact Hierarchy

- Canonical editable source: `wolfram/build_one_postulate_notebook.wl`
- Frozen plan: `wolfram/notebook_plan.md`
- Generated notebook: `wolfram/notebooks/one_postulate_explainer.nb`
- Hero asset: `wolfram/assets/notebook_hero_overview.svg`
- Supporting assets:
  - `wolfram/assets/notebook_preview_branches.svg`
  - `wolfram/assets/notebook_preview_killing_form.svg`
  - `wolfram/assets/notebook_preview_spacetime.svg`
  - `wolfram/assets/notebook_preview_crosswalk.svg`
- Public entry surfaces:
  - `README.md`
  - `docs/notebooks.md`

SVG is canonical. Do not add PNG fallbacks unless a concrete readability or
sharing problem appears during the build-and-consistency pass.

## Notebook Section Titles

1. `One Postulate in Wolfram`
2. `What this notebook is for`
3. `One parameter, three worlds`
4. `The transformation law and the Galilean limit`
5. `The kinematic bracket family`
6. `Computing the Killing form`
7. `Why the Killing form decides the geometry`
8. `Velocity-space and spacetime consequences`
9. `Three branches, three verdicts`
10. `How this connects to the Lean proof`
11. `What is computed here vs proved in Lean`

## README Section Order

1. `One Postulate, One Parameter`
2. `Three Worlds from κ`
3. `The Kinematic Bracket Family`
4. `The Killing Form Pivot`
5. `Velocity-Space and Spacetime Consequences`
6. `What Is Computed Here vs Proved in Lean`
7. `Explore the Wolfram Workbook`
8. `Lean Crosswalk`

README scope rules:

- Use one hero visual plus at most three supporting visuals.
- Keep theorem density low and the landing page cognitively light.
- Keep any proof-map content compact; deeper proof density belongs in the
  notebook and docs.

## Crosswalk Schema

Use the same columns wherever the public crosswalk appears:

- `Narrative stage`
- `Computed / visualized here`
- `Lean anchors`
- `Source of authority`

## Visual System Brief

- Tone: editorial, public-facing, mathematically serious, light-mode friendly
- Palette:
  - off-white background
  - charcoal text
  - Lorentzian branch: deep blue
  - Galilean branch: muted green/teal
  - Euclidean branch: warm amber/rust
  - structural accents: slate/gray
- Typography hierarchy:
  - strong title treatment
  - clear section headings
  - compact labels
  - short narrative captions
- Caption style: 1-2 sentence narrative captions, sentence case, no
  theorem-dense prose
- Label style: short, direct, sentence-case callouts
- Panel logic:
  - clean card and panel layouts
  - multi-panel comparisons where contrast helps
  - consistent spacing and callout placement
- Asset geometry:
  - hero asset at 16:9
  - supporting assets at 4:3 or 3:2
  - keep the set visually consistent
- GitHub assumptions:
  - optimize for light mode first
  - preserve strong contrast at narrow embed sizes
- Naming conventions:
  - `notebook_hero_*` for hero exports
  - `notebook_preview_*` for supporting exports

## Wolfram MCP Usage Boundary

Use Wolfram MCP for:

- symbolic algebra
- exact simplification
- matrix computations
- parameter sweeps
- figure data generation
- interactive visualization generation
- notebook construction support

Do not use Wolfram MCP as the source of truth for:

- theorem names
- Lean module names
- proof-structure claims
- paper claims

Those come from local repository inspection only.

## Required Interactive Elements

Implement exactly three meaningful interactive sections:

1. A `κ` regime `Manipulate` answering: what changes when `κ` changes sign?
2. A dynamic Killing-form block panel answering: what happens to the boost
   block at `κ = 0`?
3. A branch comparison or spacetime consequences panel answering: how do the
   three regimes differ geometrically?

Each interactive section must remain understandable in its default static
state. Interaction must teach, not decorate.

## Lean Crosswalk Anchors

Use these exact, locally verified anchors:

- `matrix_bracket_JJ`, `matrix_bracket_JK`, `matrix_bracket_KK`
- `kinematic_bracket_table`, `kinematic_bracket_jacobi`,
  `boostCommutator_scales_with_kappa`
- `killing_form_diag`, `boost_killing_form_eq`,
  `boost_killing_nondegenerate_iff_kappa_ne_zero`
- `killing_restricts_to_metric`, `zero_kappa_velocity_metric_only_conformal`,
  `invariantSpeedSquared_formula`
- `spacetime_metric_eq_diagonal`, `spacetime_metric_invariant`,
  `reducible_of_kappa_zero`, `spacetime_metric_congruent_stdLorentz_of_kappa_pos`
- `positive_kappa_selects_lorentz`, `zero_kappa_selects_galilean`,
  `negative_kappa_selects_euclidean`, `negative_kappa_no_nonzero_null_vectors`,
  `positive_kappa_gives_finite_real_invariant_speed`
- `phase1_selection_summary`, `classification_derivation_complete`,
  `classification_derivation_complete_full`

Guarded boundary reminder:

- `OnePostulate.lean` remains the guarded phase-1 root.
- `OnePostulateFull.lean` remains the full-paper root.
- `OnePostulate/ClassificationDerivation.lean` remains supplemental/full-paper
  material.

## Narrative Contract

The public narrative should explain:

- the one-parameter family controlled by `κ`
- the bracket structure and why it matters
- the Killing form as the decisive invariant
- the Euclidean / Galilean / Lorentzian branch split
- how notebook computations relate to Lean proofs
- what is computed in the notebook versus what is formally proved in Lean

Notebook and README must distinguish:

- computed or symbolically checked here
- formally proved in Lean
- interpretive narrative from the paper

## Definition of Done

The work is only done when all of the following are true:

- `AGENTS.md` is explicitly updated first and aligned to this workflow
- the notebook is generated successfully, or as far as the local Wolfram
  environment permits
- the notebook is clearly narrative-first and visualization-first
- at least four polished exported visuals exist
- `wolfram/assets/notebook_hero_overview.svg` exists
- at least two interactive sections teach a real concept
- `README.md` has no broken image references
- README and notebook follow the same conceptual sequence
- every "computed here" claim corresponds to an actual Wolfram computation or
  generated figure
- every public Lean crosswalk anchor is exact and locally verified
- no stale public references remain to `notebooks/one_postulate_explainer.nb`
  or `docs/assets/notebook_preview_*`
- no Lean proof boundary was widened
