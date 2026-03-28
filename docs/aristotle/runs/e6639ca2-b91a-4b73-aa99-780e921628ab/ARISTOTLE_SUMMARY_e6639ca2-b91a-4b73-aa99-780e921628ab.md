# Summary of changes
## Validation Complete: Lean Surface vs `paper/one-postulate.tex`

**Result: No mismatches found.** The full validation report is in `VALIDATION_REPORT.md`.

### Summary

I validated `OnePostulateFull.lean` and `OnePostulate/ClassificationDerivation.lean` against `paper/one-postulate.tex` as the sole source of truth. The project builds cleanly (0 sorries, 3164 jobs).

**All constraints satisfied:**
- `ClassificationDerivation` is not imported into `OnePostulate.lean`
- All theorem statements and imports preserved
- Matrix-first development intact
- No widening of the main imported root

**Claim-by-claim verification (all ✅):**

| Paper Claim | Lean Coverage |
|---|---|
| Killing form = diag(−4I₃, 4κI₃) | `killing_form_diag` — exact match |
| Connected to Mathlib's abstract `killingForm` | `mathlib_killingForm_eq_explicit_on_basis` |
| [Kᵢ, Kⱼ] = −κεᵢⱼₖJₖ | `kinematic_bracket_table` — exact match |
| κ < 0: no causal structure, definite metric | `classificationNegativeBranch` — no null vectors |
| κ = 0: Killing blind on boosts, dt invariant, metric = dt² only, reducible representation | `classificationZeroBranch` — all 8 conditions proven |
| κ = 0 full: unique invariant form ∝ dt² (Schur) | `classificationZeroBranchFull` |
| κ > 0: non-degenerate Killing, V = 1/√κ, Lorentzian metric, no absolute time | `classificationPositiveBranch` — all 7 conditions proven |
| κ > 0 full: unique invariant form ∝ diag(1,−κ,−κ,−κ) (Schur) | `classificationPositiveBranchFull` |
| Spacetime metric g = diag(1, −κ, −κ, −κ) | `spacetime_metric_eq_diagonal` — exact match |
| Three-way classification trichotomy | `classificationDerivationComplete[Full]` |

**Items not separately named as theorems but mathematically implicit:**
- "Killing form negative definite for κ < 0" (follows from `killing_form_diag`)
- Lie group labels (SO(4), ISO(3), SO(3,1)) — Lean uses `Branch` enum instead
- Explicit Lorentz transformations (group-level; formalization is Lie-algebra level)

No corrections were needed. The report is at `VALIDATION_REPORT.md`.