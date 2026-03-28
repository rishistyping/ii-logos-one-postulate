# Validation Report: Lean Formalization vs. `paper/one-postulate.tex`

**Scope**: `OnePostulate.lean`, `OnePostulate/SpacetimeRepresentation.lean`, `OnePostulate/Selection.lean`  
(with upstream dependencies `Basic.lean`, `SpacetimeMatrices.lean`, `KinematicAlgebra.lean`, `KillingForm.lean`, `VelocitySpace.lean` read for context)

**Paper source of truth**: `paper/one-postulate.tex`

---

## Build & Soundness Status

| Check | Result |
|---|---|
| `lake build OnePostulate` | ✅ Success (3162 jobs, linter warnings only) |
| `sorry` in main import surface | ✅ None |
| Axioms used | ✅ `propext`, `Classical.choice`, `Quot.sound` only |
| `OnePostulate.ClassificationDerivation` imported? | ✅ No (correctly excluded) |

Linter warnings are cosmetic only (unused simp args in `SpacetimeRepresentation.lean` lines 171, 179, 277, 298, 335; unreachable tactics). No correctness impact.

---

## Claim-by-Claim Alignment

### 1. Lie Bracket Relations (Paper §"What the postulate determines")

**Paper**: Six generators (J₁,J₂,J₃,K₁,K₂,K₃) with:
- `[Jᵢ, Jⱼ] = εᵢⱼₖ Jₖ`
- `[Jᵢ, Kⱼ] = εᵢⱼₖ Kₖ`
- `[Kᵢ, Kⱼ] = −κ εᵢⱼₖ Jₖ`

**Lean** (`KinematicAlgebra.lean`):
- `kinematic_bracket_table` — all three relations proven ✅

**Verdict**: **Match.** The bracket table is proved via matrix realization (`SpacetimeMatrices.lean`) and lifted to the abstract Lie algebra.

---

### 2. Killing Form Diagonal (Paper §"Can the rules examine themselves?")

**Paper**: *B = diag(−4 I₃, 4κ I₃)* — "the Killing form registers −4 on every rotation and 4κ on every boost."

**Lean** (`KillingForm.lean`):
- `killing_form_diag`: `killingFormMatrix κ = diag(-4, -4, -4, 4*κ, 4*κ, 4*κ)` ✅
- `mathlib_killingForm_eq_explicit_on_basis`: connects to Mathlib's abstract `killingForm` ✅

**Verdict**: **Match.** Both the explicit computation and the bridge to Mathlib's abstract definition are proven.

---

### 3. Killing Form on Boost Subspace (Paper §"Can the rules examine themselves?" / Figure 2)

**Paper**: *B(Kᵢ, Kⱼ) = 4κ δᵢⱼ*; non-degenerate iff κ ≠ 0.

**Lean** (`KillingForm.lean` / `VelocitySpace.lean`):
- `boost_killing_form_eq`: `boostKillingBlock κ = diag(4*κ, 4*κ, 4*κ)` ✅
- `boost_killing_nondegenerate_iff_kappa_ne_zero` ✅

**Verdict**: **Match.**

---

### 4. Velocity-Space Schur Lemma (Paper: "Schur's lemma, the unique SO(3)-invariant form…")

**Paper**: The SO(3)-invariant symmetric form on the boost subspace is forced to be ∝ δᵢⱼ.

**Lean** (`VelocitySpace.lean`):
- `boost_invariant_form_scalar`: any symmetric SO(3)-commuting 3×3 matrix is `c · I₃` ✅
- `boost_metric_fixed_by_killing_if_kappa_ne_zero`: normalization matches Killing form ✅

**Verdict**: **Match.**

---

### 5. Invariant Speed V = 1/√κ (Paper §"Three verdicts", κ > 0)

**Paper**: "the Killing form fixes the radius at V = 1/√κ, finite, real, and the same in all frames."

**Lean** (`VelocitySpace.lean` / `Selection.lean`):
- `invariantSpeedSquared_formula`: `invariantSpeedSquared κ = κ⁻¹` ✅
- `positive_kappa_gives_finite_real_invariant_speed`: `0 < κ⁻¹ ∧ ∃ c > 0, c² = κ⁻¹` ✅

**Verdict**: **Match.**

---

### 6. Spacetime Metric (Paper: "g ∝ diag(1, −κ, −κ, −κ)")

**Paper**: "The invariant metric is g ∝ diag(1, −κ, −κ, −κ)."

**Lean** (`SpacetimeRepresentation.lean`):
- `spacetime_metric_eq_diagonal`: `spacetime_metric κ = diag(1, -κ, -κ, -κ)` ✅
- `spacetime_metric_invariant`: invariant under all generators ✅

**Verdict**: **Match.**

---

### 7. Spacetime Schur Uniqueness (Paper: "the algebra determines this quadratic form uniquely, by Schur's lemma")

**Paper**: The invariant symmetric spacetime form is unique up to scalar (for κ ≠ 0).

**Lean** (`SpacetimeRepresentation.lean`):
- `rotation_invariant_symmetric_forms_shape`: rotation-invariance forces diag(a,b,b,b) ✅
- `spacetime_invariant_symmetric_form_scalar_of_kappa_ne_zero`: full invariance + κ≠0 ⟹ ∃ c, G = c · metric ✅
- `galilean_invariant_symmetric_form_eq_dt2_scalar`: κ=0 ⟹ ∃ c, G = c · diag(1,0,0,0) ✅

**Verdict**: **Match.** Both the κ≠0 and κ=0 cases are covered.

---

### 8. κ < 0 Verdict: No Causal Structure (Paper §"Three verdicts")

**Paper**: "no lightcone, no causal ordering"; metric is positive definite (Euclidean signature).

**Lean** (`Selection.lean`):
- `negative_kappa_selects_euclidean` ✅
- `negative_kappa_no_nonzero_null_vectors`: no nonzero null vector when κ < 0 ✅

**Verdict**: **Match.** The positive-definiteness of the metric (no null vectors) directly captures "no lightcone."

---

### 9. κ = 0 Verdict: The Algebra Goes Blind (Paper §"Three verdicts")

**Paper claims**:
- Killing form returns 0 on boosts
- Boosts commute: [Kᵢ, Kⱼ] = 0
- Absolute time: dt is invariant
- Spacetime metric degenerates to dt² only
- Representation is reducible (time line is a proper invariant subspace)

**Lean** (`SpacetimeRepresentation.lean` / `Selection.lean`):
- `boost_killing_form_vanishes_at_zero`: boostKillingBlock 0 = 0 ✅
- `[Kᵢ, Kⱼ] = -0·εᵢⱼₖ Jₖ = 0` follows from `kinematic_bracket_table` at κ=0 ✅ (implicit, not standalone)
- `absoluteTimeCovector_bracket_zero`: dt invariant under full κ=0 algebra ✅
- `galilean_invariant_symmetric_form_eq_dt2_scalar`: metric ∝ diag(1,0,0,0) ✅
- `spacetime_metric_degenerate_of_kappa_zero`: metric is degenerate ✅
- `reducible_of_kappa_zero`: timeLineSubmodule ≠ ⊥ ∧ ≠ ⊤ ✅

**Verdict**: **Match.** All five sub-claims are formally captured.

---

### 10. κ > 0 Verdict: Everything Is Determined (Paper §"Three verdicts")

**Paper claims**:
- Finite real invariant speed
- Lorentzian signature (congruent to diag(1,−1,−1,−1))
- No invariant covector (no absolute time)
- Velocity metric non-degenerate

**Lean** (`SpacetimeRepresentation.lean` / `Selection.lean`):
- `positive_kappa_gives_finite_real_invariant_speed` ✅
- `spacetime_metric_congruent_stdLorentz_of_kappa_pos` ✅
- `no_nonzero_invariant_covector_of_kappa_pos` ✅
- `absolute_time_line_not_invariant_of_kappa_pos` ✅
- `selection_of_positive_kappa`: bundles all of the above ✅

**Verdict**: **Match.**

---

### 11. Summary Table (Paper §"Three verdicts", table)

**Lean** (`Selection.lean`):
- `phase1_selection_summary`: three-branch conditional covering all κ ✅
- `full_paper_selection_summary`: extended version adding Schur uniqueness for both κ=0 and κ>0 ✅

**Verdict**: **Match.** The `full_paper_selection_summary` theorem is a faithful formalization of the paper's summary table.

---

## Gaps (Not Mismatches)

These are paper claims not formalized in the main import surface. They are **not contradictions** — they are coverage boundaries of the phase-1 development.

| Paper Claim | Status | Notes |
|---|---|---|
| "imaginary" invariant speed for κ < 0 | Unstated | Trivially follows from `invariantSpeedSquared κ = κ⁻¹ < 0` when κ < 0, but no standalone theorem |
| Compact group SO(4) for κ < 0 | Unstated | Paper says group is compact; not formalized (abstract group theory, beyond matrix-first scope) |
| Boosts commute at κ = 0 as standalone | Implicit | Follows from bracket table at κ = 0 but not stated as `∀ i j, ⁅K i, K j⁆ = 0` |
| "Background structure needed" for κ = 0 | Captured indirectly | Via degenerate metric + reducibility + dt invariance; no single "background structure" predicate |

---

## Mismatches Found

**None.** All theorem statements in `OnePostulate.lean`, `OnePostulate/SpacetimeRepresentation.lean`, and `OnePostulate/Selection.lean` are correctly aligned with the claims in `paper/one-postulate.tex`. No theorem contradicts the paper. No paper claim present in the formalization scope is misstated.

---

## Structural Notes

- **Imports**: `OnePostulate.lean` correctly imports all phase-1 modules and excludes `ClassificationDerivation`. ✅
- **Matrix-first development**: Intact throughout. All definitions and proofs use explicit matrix computations. ✅
- **No widening of import root**: `OnePostulate.lean` does not import `ClassificationDerivation`. ✅
- **Theorem statements preserved**: No modifications made. ✅
