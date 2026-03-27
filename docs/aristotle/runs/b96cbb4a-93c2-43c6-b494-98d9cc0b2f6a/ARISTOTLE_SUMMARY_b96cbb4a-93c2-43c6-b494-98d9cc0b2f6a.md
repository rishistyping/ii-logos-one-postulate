# Summary of changes
## Validation Report: Phase-1 Lean ↔ Paper Alignment

I performed a systematic claim-by-claim comparison of the three target files (`OnePostulate.lean`, `OnePostulate/SpacetimeRepresentation.lean`, `OnePostulate/Selection.lean`) against `paper/one-postulate.tex`.

### Build & Axiom Status
- **All three files compile with zero `sorry`** (confirmed via `lean_build` on `OnePostulate` module).
- **Axioms are clean:** only `propext`, `Classical.choice`, `Quot.sound` — standard Lean/Mathlib axioms.

### Structural Constraints — All Satisfied
- `OnePostulate.lean` does **not** import `ClassificationDerivation` ✅
- Phase-1 root is **not** widened ✅
- `OnePostulateFull.lean` / `ClassificationDerivation.lean` are **not** used to justify main-root claims ✅
- Matrix-first development **intact** ✅
- All theorem statements and imports **preserved** (no modifications made) ✅

### Paper ↔ Lean Alignment — No Mismatches Found

Every substantive claim from the paper's Classification, Selection, and Discussion sections has a corresponding proven Lean theorem:

- **Bracket relations** (`kinematic_bracket_table`) — exact match with paper's $[J_i,J_j]=\varepsilon_{ijk}J_k$, etc.
- **Killing form** (`killing_form_diag`) — exact match: $\text{diag}(-4,-4,-4, 4\kappa, 4\kappa, 4\kappa)$
- **Mathlib bridge** (`mathlib_killingForm_eq_explicit_on_basis`) — explicit matrices agree with Mathlib's abstract `killingForm`
- **Velocity-space Schur** (`boost_invariant_form_scalar`) — unique SO(3)-invariant form up to scalar
- **Spacetime metric** (`spacetime_metric_eq_diagonal`) — $\text{diag}(1,-\kappa,-\kappa,-\kappa)$
- **κ < 0:** no null vectors (`negative_kappa_no_nonzero_null_vectors`)
- **κ = 0:** degenerate Killing form, reducible representation, only $dt^2$ invariant, absolute time covector invariant
- **κ > 0:** non-degenerate, Lorentzian congruence, unique invariant form, no invariant covector, finite real invariant speed
- **Sign conventions** all match between paper and Lean (boost matrices, Killing form entries, metric signature)

All details are in `VALIDATION_REPORT.md` with per-theorem file locations and match status tables.