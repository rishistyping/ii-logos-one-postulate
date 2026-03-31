# Notebook Companions

This repository exposes two computational surfaces alongside the Lean proof.
They are companions to the paper, not replacements for it.

- Primary public-facing Wolfram workbook: [`wolfram/notebooks/one_postulate_explainer.nb`](../wolfram/notebooks/one_postulate_explainer.nb)
- Secondary SymPy explainer: [`one_postulate_sympy_colab.ipynb`](../one_postulate_sympy_colab.ipynb)

## What The Notebooks Do

The notebooks make the paper's symbolic calculations easier to inspect.
They do not widen the proof surface and they do not replace the Lean files as
the repository's proof authority.

### Wolfram workbook

[`wolfram/notebooks/one_postulate_explainer.nb`](../wolfram/notebooks/one_postulate_explainer.nb)
is the primary public-facing computational companion. It is generated from
[`wolfram/build_one_postulate_notebook.wl`](../wolfram/build_one_postulate_notebook.wl)
and follows the frozen structure in
[`wolfram/notebook_plan.md`](../wolfram/notebook_plan.md).

- It leads with narrative and visuals, not scratchpad algebra.
- It presents the `kappa`-controlled story as a guided visual essay.
- It separates computed or visualized claims from Lean-proved claims.
- It is generated from source, so the notebook can be rebuilt reproducibly.

### SymPy notebook

[`one_postulate_sympy_colab.ipynb`](../one_postulate_sympy_colab.ipynb) remains
available as a secondary companion.

- It starts from the already-derived `1+1` transformation law.
- It checks the Galilean limit `kappa -> 0` directly.
- It adopts the homogeneous kinematics algebra used later in the paper.
- It computes the Killing form and compares the `kappa < 0`, `kappa = 0`, and
  `kappa > 0` regimes symbolically.
- It separates direct symbolic checks from the paper's higher-level physical
  reading.

## Lean Crosswalk

| Narrative stage | Computed / visualized here | Lean anchors | Source of authority |
| --- | --- | --- | --- |
| One parameter, three worlds | `kappa` regime visuals and comparison panels | `phase1_selection_summary` | Local paper + Lean |
| Transformation law and Galilean limit | exact `kappa -> 0` limit and transformation-law cells | `matrix_bracket_JJ`, `matrix_bracket_JK`, `matrix_bracket_KK` | Local paper + Lean |
| Kinematic bracket family | bracket-table display and block-structured algebra view | `kinematic_bracket_table`, `kinematic_bracket_jacobi`, `boostCommutator_scales_with_kappa` | Local paper + Lean |
| Computing the Killing form | diagonal Killing-form computation and block comparison | `killing_form_diag`, `boost_killing_form_eq`, `boost_killing_nondegenerate_iff_kappa_ne_zero` | Local paper + Lean |
| Velocity-space and spacetime consequences | boost-sector metric, spacetime metric, and regime panels | `killing_restricts_to_metric`, `zero_kappa_velocity_metric_only_conformal`, `invariantSpeedSquared_formula`, `spacetime_metric_eq_diagonal`, `spacetime_metric_invariant`, `reducible_of_kappa_zero`, `spacetime_metric_congruent_stdLorentz_of_kappa_pos` | Local paper + Lean |
| Three branches, three verdicts | branch comparison board and hero summary | `positive_kappa_selects_lorentz`, `zero_kappa_selects_galilean`, `negative_kappa_selects_euclidean`, `negative_kappa_no_nonzero_null_vectors`, `positive_kappa_gives_finite_real_invariant_speed`, `classification_derivation_complete`, `classification_derivation_complete_full` | Local paper + Lean |

## Proof Authority

- Computed or symbolically checked in the Wolfram workbook: formulas already
  adopted there, direct limits, matrix identities, regime comparisons, and
  figure generation.
- Formalized in Lean: the repository claims exposed through
  [`OnePostulate.lean`](../OnePostulate.lean),
  [`OnePostulateFull.lean`](../OnePostulateFull.lean), and the modules under
  [`OnePostulate/`](../OnePostulate).
- Narrated by the paper:
  [`paper/one-postulate.tex`](../paper/one-postulate.tex).

## Open / Present / Share

From the repository root:

```bash
wolframscript -file wolfram/build_one_postulate_notebook.wl
```

That workflow regenerates the notebook and the canonical preview assets under
`wolfram/assets/`.

- Open the notebook in a Wolfram notebook-capable environment from
  [`wolfram/notebooks/one_postulate_explainer.nb`](../wolfram/notebooks/one_postulate_explainer.nb).
- Present the story with the exported SVGs, especially
  [`wolfram/assets/notebook_hero_overview.svg`](../wolfram/assets/notebook_hero_overview.svg)
  and the supporting previews under `wolfram/assets/`.
- Share the static previews on GitHub; they are designed to stand on their own
  outside the notebook.

If your Wolfram setup supports notebook sharing or cloud publishing, use the
generated notebook as the source artifact and keep the exported SVGs as the
GitHub-safe preview layer.

## Preview Assets

The generated preview graphics are lightweight and suitable for GitHub
Markdown:

![Notebook hero overview](../wolfram/assets/notebook_hero_overview.svg)

![Kappa branch preview](../wolfram/assets/notebook_preview_branches.svg)

![Killing form preview](../wolfram/assets/notebook_preview_killing_form.svg)

![Spacetime branch preview](../wolfram/assets/notebook_preview_spacetime.svg)

![Paper-Lean crosswalk preview](../wolfram/assets/notebook_preview_crosswalk.svg)

- [`wolfram/assets/notebook_hero_overview.svg`](../wolfram/assets/notebook_hero_overview.svg)
- [`wolfram/assets/notebook_preview_branches.svg`](../wolfram/assets/notebook_preview_branches.svg)
- [`wolfram/assets/notebook_preview_killing_form.svg`](../wolfram/assets/notebook_preview_killing_form.svg)
- [`wolfram/assets/notebook_preview_spacetime.svg`](../wolfram/assets/notebook_preview_spacetime.svg)
- [`wolfram/assets/notebook_preview_crosswalk.svg`](../wolfram/assets/notebook_preview_crosswalk.svg)
