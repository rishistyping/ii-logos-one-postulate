# Validation Report: Full-Paper Lean Surface vs Paper

**Date:** 2025-01-27  
**Paper:** `paper/one-postulate.tex`  
**Lean surfaces validated:** `OnePostulateFull.lean`, `OnePostulate/ClassificationDerivation.lean`

---

## Summary

The supplemental/full-paper Lean surface (`OnePostulateFull.lean` + `OnePostulate/ClassificationDerivation.lean`) faithfully mirrors the paper's three-branch classification and branch-level conclusions. The build is clean (no errors, no `sorry`), the import boundary is correctly maintained, and all axioms are standard. No fixes were needed.

---

## Build Status

**PASS.** `lake build OnePostulateFull` succeeds (3164 jobs).  
Only warnings are unused `simp` arguments in `SpacetimeRepresentation.lean` (cosmetic linter noise, not errors).

---

## Placeholder Status

**PASS.** `grep -rn sorry` across `OnePostulate/`, `OnePostulate.lean`, and `OnePostulateFull.lean` returns no matches. All theorems are fully proved.

**Axiom check** (`#print axioms`): All key theorems (`classification_derivation_complete_full`, `classification_reduces_to_invariant_forms_full`, `classification_zero_branch_full`, `classification_positive_branch_full`) depend only on `propext`, `Classical.choice`, `Quot.sound` — all standard.

---

## Import-Surface Check

| Constraint | Status |
|---|---|
| `OnePostulate.lean` does NOT import `ClassificationDerivation` | **PASS** — confirmed by grep; comment in file documents the exclusion |
| `OnePostulateFull.lean` imports both `OnePostulate` and `OnePostulate.ClassificationDerivation` | **PASS** |
| `ClassificationDerivation.lean` imports only `OnePostulate.Selection` | **PASS** |
| `OnePostulateFull` is a default build target in `lakefile.toml` | **PASS** — listed in `defaultTargets` |
| `OnePostulateFull` extends without changing the main root | **PASS** — it is a strict superset import (`import OnePostulate` + supplemental) |

---

## Paper-to-Lean Fidelity

### Classification (paper §Classification)

| Paper claim | Lean artifact | Status |
|---|---|---|
| Brackets [J_i,J_j] = ε_{ijk}J_k, [J_i,K_j] = ε_{ijk}K_k, [K_i,K_j] = −κε_{ijk}J_k | `kinematic_bracket_table` (KinematicAlgebra.lean) | **Match** |
| Killing form B = diag(−4I₃, 4κI₃) | `killing_form_diag` (KillingForm.lean) | **Match** |
| Killing form agrees with Mathlib's abstract `killingForm` | `mathlib_killingForm_eq_explicit_on_basis` | **Match** |
| Velocity-space metric from Killing restriction: 4κδ_{ij} | `killing_restricts_to_metric` (VelocitySpace.lean) | **Match** |
| Schur's lemma on boost subspace (unique SO(3)-invariant form up to scale) | `boost_invariant_form_scalar` (VelocitySpace.lean) | **Match** |
| Invariant spacetime metric g ∝ diag(1,−κ,−κ,−κ) | `spacetime_metric_eq_diagonal` + `spacetime_metric_invariant` | **Match** |
| Invariant speed V² = 1/κ | `invariantSpeedSquared κ = κ⁻¹` (Basic.lean) + `invariantSpeedSquared_formula` | **Match** |

### Euclidean branch κ < 0 (paper §Selection, first block)

| Paper claim | Lean artifact | Status |
|---|---|---|
| Branch label: Euclidean | `preferredBranch κ = Branch.euclidean` in `classificationNegativeBranch` | **Match** |
| No lightcone / no nonzero null vectors | `∀ v ≠ 0, dotProduct v (mulVec (spacetime_metric κ) v) ≠ 0` | **Match** |
| Proved for κ < 0 | `classification_negative_branch` | **Match** |

### Galilean branch κ = 0 (paper §Selection, second block)

| Paper claim | Lean formalization | Status |
|---|---|---|
| Branch label: Galilean | `preferredBranch 0 = Branch.galilean` | **Match** |
| Degenerate boost Killing form: B(K_i,K_j) = 0 | `boostKillingBlock 0 = 0` | **Match** |
| Conformal-only velocity-space structure (velocity metric degenerate) | `¬ Matrix.Nondegenerate (velocityMetricMatrix 0)` | **Match** |
| Reducible spacetime representation | `timeLineSubmodule ≠ ⊥ ∧ timeLineSubmodule ≠ ⊤` | **Match** |
| Invariant dt (absolute time covector) | `absoluteTimeCovector ∈ timeLineSubmodule` + invariance under full algebra | **Match** |
| Invariant dt² structure: only invariant symmetric form is c·diag(1,0,0,0) | `galilean_invariant_symmetric_form_eq_dt2_scalar` in `classificationZeroBranchFull` | **Match** |
| Spacetime metric degenerate at κ=0 | `¬ Matrix.Nondegenerate (spacetime_metric 0)` | **Match** |

### Lorentz branch κ > 0 (paper §Selection, third block)

| Paper claim | Lean formalization | Status |
|---|---|---|
| Branch label: Lorentz | `preferredBranch κ = Branch.lorentz` | **Match** |
| Nondegenerate boost metric | `Matrix.Nondegenerate (velocityMetricMatrix κ)` | **Match** |
| Lorentzian spacetime metric (congruent to diag(1,−1,−1,−1)) | `lorentzCongruenceMatrix` congruence theorem | **Match** |
| Finite real invariant speed | `0 < invariantSpeedSquared κ ∧ ∃ c, 0 < c ∧ c² = invariantSpeedSquared κ` | **Match** |
| No invariant covector exists (space-time unified) | `∀ v, (∀ i, ⁅K_i, v⁆ = 0) → v = 0` | **Match** |
| dt not invariant under boosts | `∃ i, ⁅K_i, dt⁆ ∉ absoluteTimeLine` | **Match** |
| Unique invariant symmetric form: c · spacetime_metric κ | `spacetime_invariant_symmetric_form_scalar_of_kappa_pos` in `classificationPositiveBranchFull` | **Match** |

### Bridge from matrix-first phase-1 to full-paper packaging

| Component | Status |
|---|---|
| `classificationInputReady κ` packages the two matrix-first results (velocity metric + spacetime metric diagonal forms) | **Correct** |
| `classification_input_ready` proved from `killing_restricts_to_metric` + `spacetime_metric_eq_diagonal` | **Correct** |
| `classificationReducesToInvariantFormsFull` assembles input + all three branches with full-paper extensions | **Correct** |
| `classificationDerivationCompleteFull` gives the final trichotomy via `lt_trichotomy` | **Correct** |
| Full-paper extensions (κ=0 invariant forms, κ>0 invariant forms) sourced from `full_paper_selection_summary` | **Correct** |

---

## Issues Found

**None.** All paper claims are correctly reflected in the Lean formalization. The branch split, branch conclusions, import boundary, and proof structure are all consistent.

---

## Minimal Fixes Applied

**None required.** No paper-to-Lean mismatches, no false statements, and no import boundary violations were found.

---

## Remaining Warnings

Three `linter.unusedSimpArgs` warnings in `SpacetimeRepresentation.lean` (lines 283, 298, 335) for unused `Fin.sum_univ_four` arguments in `simp` calls. These are cosmetic and do not affect correctness.

---

## Final Recommendation

**Ship as-is.** The supplemental/full-paper Lean surface is a faithful, sorry-free, axiom-clean formalization of the paper's three-branch classification. The import boundary is correctly maintained: `OnePostulate.lean` serves as the main root without importing `ClassificationDerivation`, while `OnePostulateFull.lean` extends it as a strict superset. No changes are needed.
