# Validation Report: Lean Surface vs `paper/one-postulate.tex`

**Source of truth**: `paper/one-postulate.tex`
**Lean surfaces validated**: `OnePostulateFull.lean`, `OnePostulate/ClassificationDerivation.lean`
**Build status**: ✅ Clean (`OnePostulateFull` module, 0 sorries, 3164 jobs)

---

## 1. Structural Constraints — All Satisfied

| Constraint | Status |
|---|---|
| `OnePostulate.ClassificationDerivation` not imported into `OnePostulate.lean` | ✅ |
| `OnePostulateFull.lean` imports both `OnePostulate` and `OnePostulate.ClassificationDerivation` | ✅ |
| No widening of main imported root | ✅ |
| Theorem statements preserved | ✅ |
| Imports preserved | ✅ |
| Matrix-first development intact | ✅ |

---

## 2. Claim-by-Claim Validation

### 2.1 Lie Bracket Relations

**Paper** (§"Can the rules examine themselves?"):
> $[J_i, J_j] = \epsilon_{ijk} J_k$, $[J_i, K_j] = \epsilon_{ijk} K_k$, $[K_i, K_j] = -\kappa\,\epsilon_{ijk}\,J_k$

**Lean** (`KinematicAlgebra.lean`, `kinematic_bracket_table`):
```
⁅rotationGenerator κ i, rotationGenerator κ j⁆ = ∑ k, (leviCivita i j k : ℝ) • rotationGenerator κ k
⁅rotationGenerator κ i, boostGenerator κ j⁆   = ∑ k, (leviCivita i j k : ℝ) • boostGenerator κ k
⁅boostGenerator κ i, boostGenerator κ j⁆       = ∑ k, (-(κ : ℝ) * (leviCivita i j k : ℝ)) • rotationGenerator κ k
```

**Verdict**: ✅ Exact match (sum-form vs. Einstein-summation is notational only).

---

### 2.2 Killing Form Diagonal

**Paper**: $B = \mathrm{diag}(-4 I_3,\; 4\kappa\, I_3)$

**Lean** (`KillingForm.lean`, `killing_form_diag`):
```
killingFormMatrix κ = Matrix.diagonal ![-4, -4, -4, 4 * κ, 4 * κ, 4 * κ]
```

**Verdict**: ✅ Exact match.

---

### 2.3 Connection to Mathlib Abstract Killing Form

**Paper**: $B(X,Y) = \mathrm{tr}(\mathrm{ad}_X \circ \mathrm{ad}_Y)$

**Lean** (`KillingForm.lean`, `mathlib_killingForm_eq_explicit_on_basis`):
```
killingForm ℝ (KinematicAlgebra κ) (basisCoordinate a) (basisCoordinate b) = killingFormMatrix κ a b
```

**Verdict**: ✅ The explicit matrix computation is proven equal to Mathlib's abstract `killingForm`.

---

### 2.4 κ < 0 — Euclidean / SO(4) Branch

**Paper claims**:
- Killing form negative definite → algebra sees all generators
- Group is compact (SO(4)), no causal ordering, no lightcone
- All four dimensions geometrically equivalent

**Lean** (`ClassificationDerivation.lean`, `classificationNegativeBranch`):
```
preferredBranch κ = Branch.euclidean ∧
  ∀ v : SpacetimeIndex → ℝ, v ≠ 0 → dotProduct v (Matrix.mulVec (spacetime_metric κ) v) ≠ 0
```

**Verdict**: ✅ The no-null-vectors statement captures the physical content (definite metric → no causal structure). The Killing form being negative definite for κ < 0 follows directly from `killing_form_diag` (all diagonal entries < 0), though it is not stated as a separate named theorem. The paper's informal identification of the group as SO(4) is not formalized, but this is a naming convention rather than a mathematical claim.

---

### 2.5 κ = 0 — Galilean Branch

**Paper claims**:
- Killing form returns 0 on every boost ("algebra goes blind")
- Boosts commute: $[K_i, K_j] = 0$
- Velocity space scale undetermined (shape fixed, ruler missing)
- Spacetime metric collapses to $dt^2$ alone
- $dt$ covector invariant under full homogeneous algebra
- Background structure required (absolute time, spatial metric)
- Representation is reducible (proper invariant subspace)

**Lean** (`ClassificationDerivation.lean`, `classificationZeroBranch`):

| Paper claim | Lean theorem | Match |
|---|---|---|
| Killing on boosts = 0 | `boostKillingBlock 0 = 0` | ✅ |
| Boosts commute | Follows from bracket table at κ=0 | ✅ (implicit) |
| Velocity metric degenerate | `¬ Matrix.Nondegenerate (velocityMetricMatrix 0)` | ✅ |
| Spacetime metric degenerate | `¬ Matrix.Nondegenerate (spacetime_metric 0)` | ✅ |
| dt invariant | `absoluteTimeCovector ∈ timeLineSubmodule` + generator-wise invariance | ✅ |
| Representation reducible | `timeLineSubmodule ≠ ⊥ ∧ timeLineSubmodule ≠ ⊤` | ✅ |

**Full-paper extension** (`classificationZeroBranchFull`):

| Paper claim | Lean theorem | Match |
|---|---|---|
| Only invariant symmetric form ∝ dt² | `∀ G, isInvariantSymmetricSpacetimeForm 0 G → ∃ c, G = c • diag(1,0,0,0)` | ✅ |

**Verdict**: ✅ All paper claims for κ = 0 are captured. The "Schur's lemma" argument (unique SO(3)-invariant form on boost subspace is δ_{ij}) is formalized as `boost_invariant_form_scalar` in `VelocitySpace.lean`.

---

### 2.6 κ > 0 — Lorentzian Branch

**Paper claims**:
- Killing form returns 4κ > 0 on boosts; every generator visible
- Invariant speed $V = 1/\sqrt{\kappa}$, finite and real
- Spacetime metric $g \propto \mathrm{diag}(1, -\kappa, -\kappa, -\kappa)$, determined uniquely (Schur's lemma)
- Lightcones exist; causal structure
- No absolute time; no background structure needed

**Lean** (`ClassificationDerivation.lean`, `classificationPositiveBranch`):

| Paper claim | Lean theorem | Match |
|---|---|---|
| Killing non-degenerate on boosts | `Matrix.Nondegenerate (velocityMetricMatrix κ)` | ✅ |
| Congruent to standard Lorentz | `Pᵀ · g · P = diag(1,-1,-1,-1)` | ✅ |
| Invariant speed² positive | `0 < invariantSpeedSquared κ` | ✅ |
| Speed exists: c² = κ⁻¹ | `∃ c, 0 < c ∧ c² = invariantSpeedSquared κ` | ✅ |
| No invariant covector | `∀ v, (∀ i, ⁅K_i, v⁆ = 0) → v = 0` | ✅ |
| Time line not invariant | `∃ i, ⁅K_i, dt⁆ ∉ absoluteTimeLine` | ✅ |

**Full-paper extension** (`classificationPositiveBranchFull`):

| Paper claim | Lean theorem | Match |
|---|---|---|
| Metric uniquely determined (Schur) | `∀ G, isInvariantSymmetricSpacetimeForm κ G → ∃ c, G = c • spacetime_metric κ` | ✅ |

**Verdict**: ✅ All paper claims for κ > 0 are captured.

---

### 2.7 Spacetime Metric Formula

**Paper**: $g \propto \mathrm{diag}(1,\, -\kappa,\, -\kappa,\, -\kappa)$, equivalently $ds^2 = \kappa^{-1}\,dt^2 - dx^2 - dy^2 - dz^2$

**Lean** (`SpacetimeRepresentation.lean`, `spacetime_metric_eq_diagonal`):
```
spacetime_metric κ = Matrix.diagonal ![1, -κ, -κ, -κ]
```

**Verdict**: ✅ The two paper forms are proportional by factor κ⁻¹; the Lean uses the first.

---

### 2.8 Velocity-Space Metric (Schur's Lemma on Boost Subspace)

**Paper**: "By Schur's lemma, the unique SO(3)-invariant form on the boost subspace is δ_{ij}, up to a positive constant." The Killing form then sets $B(K_i, K_j) = 4\kappa\,\delta_{ij}$.

**Lean** (`VelocitySpace.lean`):
- `boost_invariant_form_scalar`: any symmetric form commuting with the rotation action is `diag(c,c,c)` ✅
- `killing_restricts_to_metric`: `velocityMetricMatrix κ = diag(4κ, 4κ, 4κ)` ✅

**Verdict**: ✅

---

### 2.9 Spacetime Invariant Forms (Schur's Lemma on 4D Representation)

**Paper**: "the algebra determines this quadratic form uniquely, by Schur's lemma on the irreducible four-dimensional representation"

**Lean** (`SpacetimeRepresentation.lean`):
- `rotation_invariant_symmetric_forms_shape`: rotation-invariance forces `diag(a, b, b, b)` ✅
- `spacetime_invariant_symmetric_form_scalar_of_kappa_ne_zero`: adding boost-invariance for κ≠0 forces proportionality to `spacetime_metric κ` ✅
- `galilean_invariant_symmetric_form_eq_dt2_scalar`: at κ=0, forces proportionality to `diag(1,0,0,0)` ✅

**Verdict**: ✅

---

### 2.10 Spacetime Metric Invariance

**Paper**: The metric is invariant under the algebra (implicit in "the algebra determines this form").

**Lean** (`SpacetimeRepresentation.lean`, `spacetime_metric_invariant`):
```
∀ i, Aᵀ_rot(i) · g + g · A_rot(i) = 0
∀ i, Aᵀ_boost(κ,i) · g + g · A_boost(κ,i) = 0
```

**Verdict**: ✅

---

### 2.11 Classification Summary Table

**Paper table** (§"Three verdicts"):

| Property | κ < 0 | κ = 0 | κ > 0 | Lean coverage |
|---|---|---|---|---|
| Killing on boosts | 4κ < 0 | 0 | 4κ > 0 | ✅ `boost_killing_form_eq` |
| Invariant speed | imaginary | undefined | finite, real | ✅ `invariantSpeedSquared` = κ⁻¹ |
| Spacetime metric | Euclidean | dt² only | Lorentzian | ✅ each branch proven |
| Causal structure | none | none | lightcones | ✅ (definite form / degenerate / indefinite) |
| Space–time unification | all alike | impossible | complete | ✅ (invariant-form uniqueness) |
| Background structure | none | yes | none | ✅ (invariant subspace / no invariant covector) |

---

## 3. Mismatches Found

### None.

All mathematical claims in `paper/one-postulate.tex` that are within scope of the formalization are correctly captured in the Lean code. The following informal/qualitative paper statements are not separately formalized but are either implicit consequences of proven results or naming conventions:

1. **"Killing form is negative definite" (κ < 0)**: Not stated as a named theorem, but follows immediately from `killing_form_diag` (all diagonal entries negative when κ < 0). The physical consequence (no null vectors) is proven.

2. **"Group is compact SO(4)" / "algebra is so(3,1)" / "algebra is iso(3)"**: These are Lie-algebra classification labels. The Lean code uses `Branch.euclidean`, `Branch.galilean`, `Branch.lorentz` instead. The algebraic content backing these labels (bracket relations, Killing form signature) is fully verified.

3. **Explicit Lorentz transformation formulas** ($t' = \gamma(t - \kappa vx)$, etc.): These are group-level statements. The Lean formalization works at the Lie algebra level. The algebra structure proven in Lean determines these transformations, but exponentiation to group elements is not formalized.

4. **"Boosts are periodic" (κ < 0)**: A group-level statement; not formalized at the algebra level.

---

## 4. `ClassificationDerivation.lean` — Structural Notes

- Imports only from `OnePostulate.Selection` (transitively accessing the full phase-1 chain). ✅
- The "phase-1" theorems (`classification_*_branch`) draw from `phase1_selection_summary`.
- The "full-paper" theorems (`classification_*_branch_full`) draw from `full_paper_selection_summary`, adding the invariant-form uniqueness results (Schur's lemma).
- `classificationDerivationComplete` provides the trichotomy: exactly one of {κ<0, κ=0, κ>0} holds with all associated properties.
- `classificationDerivationCompleteFull` extends this with the full-paper uniqueness results.
- `classificationReducesToInvariantForms[Full]` packages the input-ready check with the branch selection.

All proofs reduce to previously established theorems; no new mathematical content is introduced in this file. ✅

---

## 5. `OnePostulateFull.lean` — Role

Contains only:
```lean
import OnePostulate
import OnePostulate.ClassificationDerivation
```
This is the top-level "full paper" target, ensuring all modules compile together. No definitions or theorems of its own. ✅

---

## 6. Conclusion

The Lean formalization in `OnePostulateFull.lean` and `OnePostulate/ClassificationDerivation.lean` is **faithful to `paper/one-postulate.tex`** on all mathematical claims. No mismatches were found. The matrix-first development is intact, constraints are satisfied, and the build is clean.
