# Summary of changes
## Validation Complete

I performed a systematic claim-by-claim validation of the main imported surface (`OnePostulate.lean`, `OnePostulate/SpacetimeRepresentation.lean`, `OnePostulate/Selection.lean`) against `paper/one-postulate.tex`.

### Results

- **Build**: ✅ Clean (`lake build OnePostulate`, 3162 jobs, linter warnings only — unused simp args)
- **Sorries**: ✅ None in any file of the main import surface
- **Axioms**: ✅ Only `propext`, `Classical.choice`, `Quot.sound` (all standard)
- **Mismatches found**: **None**

### Coverage Summary (11 paper claims checked)

All theorem statements are correctly aligned with the paper:

1. **Lie bracket table** `[Kᵢ,Kⱼ] = -κ εᵢⱼₖ Jₖ` — `kinematic_bracket_table` ✅
2. **Killing form** `B = diag(-4I₃, 4κI₃)` — `killing_form_diag` + Mathlib bridge ✅
3. **Boost Killing block** `B(Kᵢ,Kⱼ) = 4κδᵢⱼ` — `boost_killing_form_eq` ✅
4. **Velocity-space Schur lemma** — `boost_invariant_form_scalar` ✅
5. **Invariant speed** `V = 1/√κ` — `positive_kappa_gives_finite_real_invariant_speed` ✅
6. **Spacetime metric** `g = diag(1,-κ,-κ,-κ)` — `spacetime_metric_eq_diagonal` + invariance ✅
7. **Spacetime Schur uniqueness** — `spacetime_invariant_symmetric_form_scalar_of_kappa_ne_zero` ✅
8. **κ<0: no causal structure** — `negative_kappa_no_nonzero_null_vectors` ✅
9. **κ=0: algebra goes blind** — degenerate metric, dt invariant, reducible, Killing vanishes ✅
10. **κ>0: everything determined** — Lorentz signature, no absolute time, finite speed ✅
11. **Three-branch summary table** — `full_paper_selection_summary` ✅

### Gaps (not mismatches)

Four minor paper claims are not formalized as standalone theorems but follow trivially or are beyond matrix-first scope: imaginary speed for κ<0, compactness of SO(4), boosts-commute-at-zero as standalone, and a "background structure needed" predicate. None contradict anything formalized.

### Constraints respected

- Theorem statements: preserved (no modifications)
- Imports: preserved (no changes to `OnePostulate.lean`)
- `ClassificationDerivation` not imported into `OnePostulate.lean`
- Matrix-first development: intact

Full details in `VALIDATION_REPORT.md`.