# Validation Report: Phase-1 Lean Formalization vs `paper/one-postulate.tex`

**Scope:** `OnePostulate.lean`, `OnePostulate/SpacetimeRepresentation.lean`, `OnePostulate/Selection.lean`
(with supporting files `Basic.lean`, `SpacetimeMatrices.lean`, `KinematicAlgebra.lean`, `KillingForm.lean`, `VelocitySpace.lean`).

**Build status:** ✅ All three target files compile with no `sorry`. Only cosmetic linter warnings (unused simp args, unreachable tactics).

**Axiom audit:** ✅ All theorems depend only on `propext`, `Classical.choice`, `Quot.sound` — the standard Lean/Mathlib axioms.

---

## 1. Structural Constraints — All Satisfied

| Constraint | Status |
|---|---|
| `OnePostulate.lean` does NOT import `ClassificationDerivation` | ✅ Confirmed |
| Phase-1 root not widened | ✅ Imports: Basic, SpacetimeMatrices, KinematicAlgebra, KillingForm, VelocitySpace, SpacetimeRepresentation, Selection |
| `OnePostulateFull.lean` / `ClassificationDerivation.lean` not used to justify main-root claims | ✅ All theorems in scope are self-contained |
| Matrix-first development intact | ✅ All definitions and proofs use explicit `Fin n → Fin n → ℝ` matrices |
| Theorem statements preserved | ✅ No statement modifications made |
| Imports preserved | ✅ No import changes made |

---

## 2. Paper Claim ↔ Lean Theorem Alignment

### Classification Section

| Paper Claim | Lean Theorem | File | Match |
|---|---|---|---|
| Bracket relations: $[J_i,J_j]=\varepsilon_{ijk}J_k$, $[J_i,K_j]=\varepsilon_{ijk}K_k$, $[K_i,K_j]=-\kappa\varepsilon_{ijk}J_k$ | `kinematic_bracket_table` | KinematicAlgebra.lean | ✅ Exact |
| Three branches: Lorentz ($\kappa>0$), Galileo ($\kappa=0$), Euclid ($\kappa<0$) | `classifyKappa`, `Branch` | Basic.lean | ✅ Exact |
| Killing form: $B=\text{diag}(-4I_3, 4\kappa I_3)$ | `killing_form_diag` | KillingForm.lean | ✅ Exact |
| Killing form matches Mathlib's abstract `killingForm` on basis | `mathlib_killingForm_eq_explicit_on_basis` | KillingForm.lean | ✅ Exact |
| Velocity-space SO(3)-invariant form unique up to scalar (Schur) | `boost_invariant_form_scalar` | VelocitySpace.lean | ✅ Exact |
| Killing form restricts to velocity metric: $B(K_i,K_j)=4\kappa\delta_{ij}$ | `boost_killing_form_eq`, `killing_restricts_to_metric` | KillingForm.lean, VelocitySpace.lean | ✅ Exact |
| Invariant spacetime metric $g\propto\text{diag}(1,-\kappa,-\kappa,-\kappa)$ | `spacetime_metric_eq_diagonal` | SpacetimeRepresentation.lean | ✅ Exact |
| Metric invariance under full algebra | `spacetime_metric_invariant`, `spacetime_metric_isInvariantSymmetricSpacetimeForm` | SpacetimeRepresentation.lean | ✅ Exact |
| Squared invariant speed $V^2=1/\kappa$ | `invariantSpeedSquared` (def), `invariantSpeedSquared_formula` | Basic.lean, VelocitySpace.lean | ✅ Exact |

### Selection Section — $\kappa < 0$ (Euclidean)

| Paper Claim | Lean Theorem | File | Match |
|---|---|---|---|
| Branch is Euclidean | `negative_kappa_selects_euclidean` | Selection.lean | ✅ Exact |
| Euclidean signature: no nonzero null vectors | `negative_kappa_no_nonzero_null_vectors` | Selection.lean | ✅ Exact |

### Selection Section — $\kappa = 0$ (Galilean)

| Paper Claim | Lean Theorem | File | Match |
|---|---|---|---|
| Branch is Galilean | `zero_kappa_selects_galilean` | Selection.lean | ✅ Exact |
| Killing form degenerates on boost sector: $B(K_i,K_j)=0$ | `boost_killing_form_vanishes_at_zero` | VelocitySpace.lean | ✅ Exact |
| Only conformal class fixed (not metric) | `zero_kappa_velocity_metric_only_conformal` | VelocitySpace.lean | ✅ Exact |
| Velocity metric degenerate | `velocityMetricMatrix_at_zero` | VelocitySpace.lean | ✅ Exact |
| Spacetime representation reducible | `reducible_of_kappa_zero` (timeLineSubmodule ≠ ⊥ ∧ ≠ ⊤) | SpacetimeRepresentation.lean | ✅ Exact |
| Only invariant form is $dt^2$ | `galilean_invariant_symmetric_form_eq_dt2_scalar` | SpacetimeRepresentation.lean | ✅ Exact |
| Covector $dt$ invariant under full algebra | `absoluteTimeCovector_bracket_zero`, `absoluteTimeCovector_invariant_at_kappa_zero` | SpacetimeRepresentation.lean, Selection.lean | ✅ Exact |
| Spacetime metric degenerate | `spacetime_metric_degenerate_of_kappa_zero` | SpacetimeRepresentation.lean | ✅ Exact |
| `timeLineSubmodule` is a genuine `LieSubmodule` | `timeLineSubmodule` (def + `lie_mem` proof) | SpacetimeRepresentation.lean | ✅ Exact |

### Selection Section — $\kappa > 0$ (Lorentzian)

| Paper Claim | Lean Theorem | File | Match |
|---|---|---|---|
| Branch is Lorentz | `positive_kappa_selects_lorentz` | Selection.lean | ✅ Exact |
| Killing form non-degenerate | `boost_killing_nondegenerate_iff_kappa_ne_zero` | KillingForm.lean | ✅ Exact |
| Velocity metric non-degenerate | `selection_of_positive_kappa` (conjunct 2) | Selection.lean | ✅ Exact |
| Spacetime metric Lorentzian (congruent to diag(1,−1,−1,−1)) | `spacetime_metric_congruent_stdLorentz_of_kappa_pos` | SpacetimeRepresentation.lean | ✅ Exact |
| Unique invariant symmetric spacetime form (up to scalar) | `spacetime_invariant_symmetric_form_scalar_of_kappa_pos` | SpacetimeRepresentation.lean | ✅ Exact |
| No nonzero invariant covector | `no_nonzero_invariant_covector_of_kappa_pos` | SpacetimeRepresentation.lean | ✅ Exact |
| Absolute time line not invariant | `absolute_time_line_not_invariant_of_kappa_pos` | SpacetimeRepresentation.lean | ✅ Exact |
| Finite real invariant speed exists | `positive_kappa_gives_finite_real_invariant_speed` | Selection.lean | ✅ Exact |

### Summary / Discussion Theorems

| Paper Claim | Lean Theorem | File | Match |
|---|---|---|---|
| Full three-way classification summary | `phase1_selection_summary` | Selection.lean | ✅ Exact |
| Extended summary with uniqueness results | `full_paper_selection_summary` | Selection.lean | ✅ Exact |

---

## 3. Sign Conventions

| Convention | Paper | Lean | Match |
|---|---|---|---|
| Boost commutator | $[K_i,K_j] = -\kappa\varepsilon_{ijk}J_k$ | `-(κ : ℝ) * (leviCivita i j k : ℝ)` coefficient | ✅ |
| Killing form rotation block | $-4\delta_{ij}$ | `diag(-4, -4, -4, …)` | ✅ |
| Killing form boost block | $4\kappa\delta_{ij}$ | `diag(…, 4*κ, 4*κ, 4*κ)` | ✅ |
| Spacetime metric | $\text{diag}(1, -\kappa, -\kappa, -\kappa)$ | `Matrix.diagonal ![1, -κ, -κ, -κ]` | ✅ |
| Boost generator $K_x$ | $(0,1)$-entry $= \kappa$, $(1,0)$-entry $= 1$ | `boostMatrix κ 0` | ✅ |
| Spacetime action | Contragredient: $\rho(X) = -X^T$ | `spacetimeActionMatrix κ x = -Mᵀ` | ✅ |

---

## 4. Proof Approach Notes

- **Irreducibility vs. uniqueness:** The paper invokes Schur's lemma for the irreducible representation at $\kappa \neq 0$. The formalization proves the uniqueness conclusion directly from the structure constants (via `rotation_invariant_symmetric_forms_shape` + boost constraint), bypassing the need to formally state and prove irreducibility or Schur's lemma. The final result — uniqueness of the invariant symmetric form up to scalar — is identical. This is a valid and more elementary proof strategy.

- **Conformal class at $\kappa = 0$:** The paper's claim "only a conformal class is fixed" is captured by `zero_kappa_velocity_metric_only_conformal`, which combines the vanishing Killing form with the existence of a free scalar parameter in the invariant form.

- **Compact boosts at $\kappa < 0$:** The paper's qualitative remark about periodic/compact boosts is not formalized as a separate theorem. The formalized claim (positive-definite metric, no null vectors) captures the essential consequence: no causal structure.

---

## 5. Mismatches Found

**None.** All theorem statements in the three target files are correctly aligned with the paper's claims. No sign errors, no missing hypotheses, no over-strong or under-strong conclusions relative to the paper.

---

## 6. Summary

The phase-1 formalization across `OnePostulate.lean`, `OnePostulate/SpacetimeRepresentation.lean`, and `OnePostulate/Selection.lean` is **fully aligned** with `paper/one-postulate.tex`. Every substantive mathematical claim in the paper's Classification, Selection, and Discussion sections has a corresponding proven Lean theorem with matching sign conventions, matching hypotheses, and matching conclusions. The matrix-first development is intact, imports are preserved, and the phase-1 root is not widened.
