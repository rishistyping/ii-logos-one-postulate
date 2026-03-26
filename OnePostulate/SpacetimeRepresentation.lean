/-
Spacetime representation skeleton for phase 1.

This module stays matrix-first. It records the paper-normalized spacetime
metric, the `κ = 0` invariant time covector as a genuine `LieSubmodule`, and
the positive-`κ` Lorentzian normal form via an explicit diagonal congruence.
-/
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.Lie.Submodule
import Mathlib.Data.Real.Sqrt
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.Tactic
import OnePostulate.VelocitySpace

namespace OnePostulate

def spacetime_metric (κ : ℝ) : RealSquareMatrix SpacetimeDim :=
  spacetimeMetricMatrix κ

def representationMetricMatrix (κ : ℝ) : RealSquareMatrix SpacetimeDim :=
  spacetime_metric κ

def absoluteTimeCovector : SpacetimeIndex → ℝ :=
  ![1, 0, 0, 0]

def absoluteTimeLine : Submodule ℝ (SpacetimeIndex → ℝ) where
  carrier := {v | v 1 = 0 ∧ v 2 = 0 ∧ v 3 = 0}
  zero_mem' := by simp
  add_mem' := by
    intro v w hv hw
    rcases hv with ⟨hv1, hv2, hv3⟩
    rcases hw with ⟨hw1, hw2, hw3⟩
    exact ⟨by simp [hv1, hw1], by simp [hv2, hw2], by simp [hv3, hw3]⟩
  smul_mem' := by
    intro a v hv
    rcases hv with ⟨hv1, hv2, hv3⟩
    exact ⟨by simp [hv1], by simp [hv2], by simp [hv3]⟩

noncomputable def spacetimeActionMatrix (κ : ℝ) (x : KinematicAlgebra κ) :
    RealSquareMatrix SpacetimeDim :=
  -Matrix.transpose (kinematicToMatrix κ x)

noncomputable def spacetimeAction (κ : ℝ) (x : KinematicAlgebra κ) (v : SpacetimeIndex → ℝ) :
    SpacetimeIndex → ℝ :=
  Matrix.mulVec (spacetimeActionMatrix κ x) v

noncomputable instance instBracketSpacetime (κ : ℝ) :
    Bracket (KinematicAlgebra κ) (SpacetimeIndex → ℝ) where
  bracket := spacetimeAction κ

noncomputable instance instLieRingModuleSpacetime (κ : ℝ) :
    LieRingModule (KinematicAlgebra κ) (SpacetimeIndex → ℝ) where
  add_lie x y m := by
    sorry
  lie_add x m n := by
    sorry
  leibniz_lie x y m := by
    sorry

noncomputable instance instLieModuleSpacetime (κ : ℝ) :
    LieModule ℝ (KinematicAlgebra κ) (SpacetimeIndex → ℝ) where
  smul_lie t x m := by
    sorry
  lie_smul t x m := by
    sorry

noncomputable def timeLineSubmodule : LieSubmodule ℝ (KinematicAlgebra 0) (SpacetimeIndex → ℝ) :=
  { absoluteTimeLine with
      lie_mem := by
        intro x v hv
        sorry }

noncomputable def lorentzCongruenceMatrix (κ : ℝ) : RealSquareMatrix SpacetimeDim :=
  Matrix.diagonal ![1, 1 / Real.sqrt κ, 1 / Real.sqrt κ, 1 / Real.sqrt κ]

theorem spacetime_metric_eq_diagonal (κ : ℝ) :
    spacetime_metric κ = Matrix.diagonal ![1, -κ, -κ, -κ] := by
  rfl

set_option maxHeartbeats 0 in
theorem spacetime_metric_invariant (κ : ℝ) :
    (∀ i : SpatialIndex,
        Matrix.transpose (rotMatrix i) * spacetime_metric κ + spacetime_metric κ * rotMatrix i = 0) ∧
    (∀ i : SpatialIndex,
        Matrix.transpose (boostMatrix κ i) * spacetime_metric κ + spacetime_metric κ * boostMatrix κ i = 0) := by
  constructor
  · intro i
    fin_cases i
    all_goals
      ext a b
      fin_cases a <;> fin_cases b <;>
        simp [spacetime_metric, spacetimeMetricMatrix, rotMatrix, Matrix.mul_apply, Fin.sum_univ_four,
          Matrix.diagonal] <;>
        ring_nf
  · intro i
    fin_cases i
    all_goals
      ext a b
      fin_cases a <;> fin_cases b <;>
        simp [spacetime_metric, spacetimeMetricMatrix, boostMatrix, Matrix.mul_apply, Fin.sum_univ_four,
          Matrix.diagonal] <;>
        ring_nf

theorem reducible_of_kappa_zero :
    timeLineSubmodule ≠ ⊥ ∧ timeLineSubmodule ≠ ⊤ := by
  constructor
  · intro hbot
    have hmem : absoluteTimeCovector ∈ timeLineSubmodule := by
      simp [absoluteTimeCovector, timeLineSubmodule, absoluteTimeLine]
    have hzero : absoluteTimeCovector = 0 := by
      simpa using
        (show absoluteTimeCovector ∈ (⊥ : LieSubmodule ℝ (KinematicAlgebra 0) (SpacetimeIndex → ℝ))
          from hbot ▸ hmem)
    have hentry := congrArg (fun v => v 0) hzero
    simp [absoluteTimeCovector] at hentry
  · intro htop
    have hmem : (![0, 1, 0, 0] : SpacetimeIndex → ℝ) ∈ timeLineSubmodule := by
      exact htop ▸ by simp
    simp [timeLineSubmodule, absoluteTimeLine] at hmem

theorem spacetime_metric_degenerate_of_kappa_zero :
    ¬ Matrix.Nondegenerate (spacetime_metric 0) := by
  rw [Matrix.nondegenerate_iff_det_ne_zero, spacetime_metric_eq_diagonal, Matrix.det_diagonal,
    Fin.prod_univ_four]
  simp

set_option maxHeartbeats 0 in
theorem spacetime_metric_congruent_stdLorentz_of_kappa_pos (κ : ℝ) (hκ : 0 < κ) :
    Matrix.transpose (lorentzCongruenceMatrix κ) * spacetime_metric κ * lorentzCongruenceMatrix κ =
      Matrix.diagonal ![1, -1, -1, -1] := by
  ext a b
  fin_cases a <;> fin_cases b <;>
    simp [lorentzCongruenceMatrix, spacetime_metric, spacetimeMetricMatrix, Matrix.mul_apply,
      Fin.sum_univ_four, Matrix.diagonal] <;>
    field_simp [hκ.ne'] <;>
    ring_nf <;>
    simp [Real.sq_sqrt hκ.le]

theorem absoluteTimeCovector_mem_timeLineSubmodule :
    absoluteTimeCovector ∈ timeLineSubmodule := by
  simp [absoluteTimeCovector, timeLineSubmodule, absoluteTimeLine]

theorem absoluteTimeCovector_invariant_at_kappa_zero (i : SpatialIndex) :
    ⁅rotationGenerator 0 i, absoluteTimeCovector⁆ = 0 ∧
      ⁅boostGenerator 0 i, absoluteTimeCovector⁆ = 0 := by
  sorry

theorem no_nonzero_invariant_covector_of_kappa_pos (κ : ℝ) (hκ : 0 < κ) :
    ∀ v : SpacetimeIndex → ℝ,
      (∀ i : SpatialIndex, ⁅boostGenerator κ i, v⁆ = 0) → v = 0 := by
  sorry

theorem absolute_time_line_not_invariant_of_kappa_pos (κ : ℝ) (hκ : 0 < κ) :
    ∃ i : SpatialIndex, ⁅boostGenerator κ i, absoluteTimeCovector⁆ ∉ (absoluteTimeLine : Set (SpacetimeIndex → ℝ)) := by
  sorry

theorem galilean_representation_metric :
    representationMetricMatrix 0 = Matrix.diagonal ![1, 0, 0, 0] := by
  rw [representationMetricMatrix, spacetime_metric_eq_diagonal]
  simp

theorem positive_kappa_suggests_lorentzian_behavior (κ : ℝ) (hκ : 0 < κ) :
    Matrix.transpose (lorentzCongruenceMatrix κ) * spacetime_metric κ * lorentzCongruenceMatrix κ =
      Matrix.diagonal ![1, -1, -1, -1] := by
  exact spacetime_metric_congruent_stdLorentz_of_kappa_pos κ hκ

end OnePostulate
