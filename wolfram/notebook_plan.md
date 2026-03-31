# One Postulate Wolfram Notebook Plan

This file freezes the narrative, interaction, and asset contract for the
Wolfram explainer workflow. The canonical editable source remains
`wolfram/build_one_postulate_notebook.wl`. The generated notebook and preview
assets should follow this plan unless the local paper or Lean files require a
source-truth correction.

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

SVG remains canonical. Keep the filenames stable and repurpose the visuals if
the notebook grows stronger.

## Notebook Section Titles

1. `One Postulate in Wolfram`
2. `What this notebook is for`
3. `The postulate`
4. `What the postulate determines`
5. `Can the rules examine themselves?`
6. `Three verdicts`
7. `Structure and scale`
8. `How this connects to the Lean proof`
9. `What is computed here vs proved in Lean`

## Reader-Facing Question And Answer Pattern

Each major section should open with one explicit question and close with one
explicit answer.

- `The postulate`
  - Question: `What kind of explanation does the relativity principle allow?`
- `What the postulate determines`
  - Question: `What changes when kappa changes sign or magnitude?`
- `Can the rules examine themselves?`
  - Question: `Can the algebra diagnose its own geometry without experiment?`
- `Three verdicts`
  - Question: `What does the self-test say in each regime?`
- `Structure and scale`
  - Question: `What still has to be calibrated by experiment?`

## Shared Exploration Suite

The notebook should contain one shared `DynamicModule` with a continuous
`kappa` state and a `TabView`. The controls should update the notebook’s
geometric story coherently rather than via isolated section widgets.

Required shared controls:

- continuous `kappa` slider
- regime snap buttons for representative `kappa < 0`, `kappa = 0`, and
  `kappa > 0` settings
- velocity slider `v`
- draggable event `(x, t)` using `LocatorPane`

Required tabs:

1. `Transformation`
2. `Killing form`
3. `Velocity space`
4. `Verdict`

## Required Interactive Content

The exploration suite must make the paper’s argument visible rather than merely
summarize it.

- `Transformation`
  - show `t'`, `x'`, and `gamma` live
  - couple the transformation readout to a Figure 1 style universe panel
  - show Lorentzian lightcones for `kappa > 0`
  - show Galilean simultaneity slices for `kappa = 0`
  - show rotation-like boost behaviour for `kappa < 0`
  - warn clearly when `kappa > 0` and `|v|` approaches `1 / Sqrt[kappa]`
- `Killing form`
  - show `B = diag(-4 I3, 4 kappa I3)` as a live matrix view
  - show determinant and eigenvalues
  - show the sign change and degeneracy of the boost sector clearly
  - include a live eigenvalue plot for `{-4, -4, -4, 4 kappa, 4 kappa, 4 kappa}`
- `Velocity space`
  - implement the Figure 2 logic directly
  - show the preferred radius `V = 1 / Sqrt[kappa]` when `kappa > 0`
  - show shape without a preferred ruler when `kappa = 0`
  - explain why the Euclidean branch does not give a real invariant speed
- `Verdict`
  - end with a paper-aligned comparison board
  - include:
    - Killing form on boosts
    - invariant speed
    - spacetime metric
    - causal structure
    - space-time unification
    - background structure needed
  - include the calibration point that experiment fixes the value, not the
    existence, of the invariant speed

## Inline Authority Badges

Every major visual panel should carry three compact inline badges:

- `Computed here`
- `Paper narrative`
- `Lean proof anchor`

The badge row should stay readable and should point to exact local theorem or
module anchors where applicable.

## Asset Meanings

- `notebook_hero_overview.svg`
  - one-parameter story -> self-test -> final verdict
- `notebook_preview_branches.svg`
  - the master Figure 1 universe comparison
- `notebook_preview_killing_form.svg`
  - the Killing-form default state, including the boost-sector story
- `notebook_preview_spacetime.svg`
  - the transformation simulator’s default state
- `notebook_preview_crosswalk.svg`
  - the later paper -> notebook -> Lean crosswalk

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
- Caption style:
  - one or two sentence narrative captions
  - sentence case
  - no theorem-dense prose
- Layout logic:
  - one strong hero overview
  - one master spacetime panel
  - one master Killing-form panel
  - one verdict board
  - crosswalk later, not first

## Lean Crosswalk Anchors

Use exact, locally verified anchors only:

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

## Boundary Of Authority

The notebook and notebook-facing docs must keep three categories distinct:

- computed or symbolically checked here
- formally proved in Lean
- interpretive narrative from the paper

Lean remains the proof authority. Wolfram computations are explanatory
companions rather than formal proofs.

## Definition Of Done

The notebook workflow is only done when all of the following are true:

- the paper-stage section order is present in the generated notebook
- the shared exploration suite exists with the four required tabs
- the notebook uses a continuous `kappa` control rather than only discrete
  branch selectors
- the transformation view uses `LocatorPane`
- the Killing-form view shows matrix structure, determinant, and eigenvalue
  behaviour
- the velocity-space view makes the missing ruler at `kappa = 0` intuitive
- the verdict board matches the paper’s comparison logic
- every major section closes with an explicit answer
- every major panel carries the inline authority badges
- the preview asset filenames are unchanged
- `docs/notebooks.md` accurately describes the revised notebook shape
- the proof boundary remains unchanged
