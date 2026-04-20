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

def isInvariantSymmetricSpacetimeForm (κ : ℝ) (G : RealSquareMatrix SpacetimeDim) : Prop :=
  Matrix.IsSymm G ∧
    (∀ i : SpatialIndex,
      Matrix.transpose (rotMatrix i) * G + G * rotMatrix i = 0) ∧
    (∀ i : SpatialIndex,
      Matrix.transpose (boostMatrix κ i) * G + G * boostMatrix κ i = 0)

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

private noncomputable def spacetimeMatrixLieHom (κ : ℝ) :
    KinematicAlgebra κ →ₗ⁅ℝ⁆ RealSquareMatrix SpacetimeDim where
  toLinearMap :=
    { toFun := spacetimeActionMatrix κ
      map_add' := by
        intro x y
        ext i j
        simp [spacetimeActionMatrix, Matrix.transpose_add, add_comm]
      map_smul' := by
        intro t x
        ext i j
        simp [spacetimeActionMatrix, Matrix.transpose_smul] }
  map_lie' := by
    intro x y
    rw [spacetimeActionMatrix, spacetimeActionMatrix, spacetimeActionMatrix, kinematicToMatrix_lie]
    ext i j
    simp [Ring.lie_def, matrixBracket, Matrix.transpose_sub, Matrix.transpose_mul]

noncomputable instance instLieRingModuleSpacetime (κ : ℝ) :
    LieRingModule (KinematicAlgebra κ) (SpacetimeIndex → ℝ) := by
  letI : LieRingModule (RealSquareMatrix SpacetimeDim) (SpacetimeIndex → ℝ) := inferInstance
  exact LieRingModule.compLieHom (SpacetimeIndex → ℝ) (spacetimeMatrixLieHom κ)

noncomputable instance instLieModuleSpacetime (κ : ℝ) :
    LieModule ℝ (KinematicAlgebra κ) (SpacetimeIndex → ℝ) := by
  letI : LieRingModule (RealSquareMatrix SpacetimeDim) (SpacetimeIndex → ℝ) := inferInstance
  letI : LieModule ℝ (RealSquareMatrix SpacetimeDim) (SpacetimeIndex → ℝ) := inferInstance
  exact LieModule.compLieHom (SpacetimeIndex → ℝ) (spacetimeMatrixLieHom κ)

private theorem kinematicToMatrix_zero_top_row (x : KinematicAlgebra 0) (j : SpacetimeIndex) :
    kinematicToMatrix 0 x 0 j = 0 := by
  fin_cases j <;>
    simp [kinematicToMatrix, basisMatrix, Fin.sum_univ_six, rotMatrix, boostMatrix]

private theorem mem_absoluteTimeLine_eq_smul (v : SpacetimeIndex → ℝ) (hv : v ∈ absoluteTimeLine) :
    v = v 0 • absoluteTimeCovector := by
  rcases hv with ⟨hv1, hv2, hv3⟩
  ext a
  fin_cases a
  · simp [absoluteTimeCovector]
  · simpa [absoluteTimeCovector] using hv1
  · simpa [absoluteTimeCovector] using hv2
  · simpa [absoluteTimeCovector] using hv3

private theorem absoluteTimeCovector_bracket_zero (x : KinematicAlgebra 0) :
    ⁅x, absoluteTimeCovector⁆ = 0 := by
  ext a
  fin_cases a
  · change (spacetimeAction 0 x absoluteTimeCovector) 0 = 0
    simp [spacetimeAction, spacetimeActionMatrix, Matrix.transpose_apply, Matrix.mulVec, dotProduct,
      Fin.sum_univ_four, absoluteTimeCovector, kinematicToMatrix_zero_top_row x 0]
  · change (spacetimeAction 0 x absoluteTimeCovector) 1 = 0
    simp [spacetimeAction, spacetimeActionMatrix, Matrix.transpose_apply, Matrix.mulVec, dotProduct,
      Fin.sum_univ_four, absoluteTimeCovector, kinematicToMatrix_zero_top_row x 1]
  · change (spacetimeAction 0 x absoluteTimeCovector) 2 = 0
    simp [spacetimeAction, spacetimeActionMatrix, Matrix.transpose_apply, Matrix.mulVec, dotProduct,
      Fin.sum_univ_four, absoluteTimeCovector, kinematicToMatrix_zero_top_row x 2]
  · change (spacetimeAction 0 x absoluteTimeCovector) 3 = 0
    simp [spacetimeAction, spacetimeActionMatrix, Matrix.transpose_apply, Matrix.mulVec, dotProduct,
      Fin.sum_univ_four, absoluteTimeCovector, kinematicToMatrix_zero_top_row x 3]

private theorem boostGenerator_bracket_eq (κ : ℝ) (i : SpatialIndex) (v : SpacetimeIndex → ℝ) :
    ⁅boostGenerator κ i, v⁆ =
      match i with
      | 0 => ![-v 1, -(κ * v 0), 0, 0]
      | 1 => ![-v 2, 0, -(κ * v 0), 0]
      | _ => ![-v 3, 0, 0, -(κ * v 0)] := by
  fin_cases i
  · change spacetimeAction κ (boostGenerator κ 0) v = _
    ext a
    fin_cases a <;>
      simp [spacetimeAction, spacetimeActionMatrix, Matrix.transpose_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_four, boostGenerator, basisMatrix, boostMatrix]
  · change spacetimeAction κ (boostGenerator κ 1) v = _
    ext a
    fin_cases a <;>
      simp [spacetimeAction, spacetimeActionMatrix, Matrix.transpose_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_four, boostGenerator, basisMatrix, boostMatrix]
  · change spacetimeAction κ (boostGenerator κ 2) v = _
    ext a
    fin_cases a <;>
      simp [spacetimeAction, spacetimeActionMatrix, Matrix.transpose_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_four, boostGenerator, basisMatrix, boostMatrix]

noncomputable def timeLineSubmodule : LieSubmodule ℝ (KinematicAlgebra 0) (SpacetimeIndex → ℝ) :=
  { absoluteTimeLine with
      lie_mem := by
        intro x v hv
        rw [mem_absoluteTimeLine_eq_smul v hv, lie_smul, absoluteTimeCovector_bracket_zero]
        simp [absoluteTimeLine] }

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

theorem spacetime_metric_isInvariantSymmetricSpacetimeForm (κ : ℝ) :
    isInvariantSymmetricSpacetimeForm κ (spacetime_metric κ) := by
  refine ⟨?_, ?_, ?_⟩
  · simpa [spacetime_metric] using spacetimeMetricMatrix_isSymm κ
  · exact (spacetime_metric_invariant κ).1
  · exact (spacetime_metric_invariant κ).2

theorem rotation_invariant_symmetric_forms_shape (G : RealSquareMatrix SpacetimeDim)
    (hSymm : Matrix.IsSymm G)
    (hRot : ∀ i : SpatialIndex,
      Matrix.transpose (rotMatrix i) * G + G * rotMatrix i = 0) :
    ∃ a b : ℝ, G = Matrix.diagonal ![a, b, b, b] := by
  have hs10 : G 1 0 = G 0 1 := by
    simpa using (Matrix.IsSymm.apply hSymm 0 1)
  have hs20 : G 2 0 = G 0 2 := by
    simpa using (Matrix.IsSymm.apply hSymm 0 2)
  have hs30 : G 3 0 = G 0 3 := by
    simpa using (Matrix.IsSymm.apply hSymm 0 3)
  have hs21 : G 2 1 = G 1 2 := by
    simpa using (Matrix.IsSymm.apply hSymm 1 2)
  have hs31 : G 3 1 = G 1 3 := by
    simpa using (Matrix.IsSymm.apply hSymm 1 3)
  have hs32 : G 3 2 = G 2 3 := by
    simpa using (Matrix.IsSymm.apply hSymm 2 3)
  have h01 : G 0 1 = 0 := by
    have h := congrArg (fun M => M 0 3) (hRot 1)
    simp [rotMatrix, Matrix.mul_apply, Fin.sum_univ_four] at h
    linarith
  have h02 : G 0 2 = 0 := by
    have h := congrArg (fun M => M 0 3) (hRot 0)
    simp [rotMatrix, Matrix.mul_apply, Fin.sum_univ_four] at h
    linarith
  have h03 : G 0 3 = 0 := by
    have h := congrArg (fun M => M 0 2) (hRot 0)
    simp [rotMatrix, Matrix.mul_apply, Fin.sum_univ_four] at h
    linarith
  have h10 : G 1 0 = 0 := by
    rw [hs10, h01]
  have h20 : G 2 0 = 0 := by
    rw [hs20, h02]
  have h30 : G 3 0 = 0 := by
    rw [hs30, h03]
  have h12 : G 1 2 = 0 := by
    have h := congrArg (fun M => M 1 1) (hRot 2)
    simp [rotMatrix, Matrix.mul_apply, Fin.sum_univ_four, hs21] at h
    linarith
  have h13 : G 1 3 = 0 := by
    have h := congrArg (fun M => M 1 1) (hRot 1)
    simp [rotMatrix, Matrix.mul_apply, Fin.sum_univ_four, hs31] at h
    linarith
  have h23 : G 2 3 = 0 := by
    have h := congrArg (fun M => M 2 2) (hRot 0)
    simp [rotMatrix, Matrix.mul_apply, Fin.sum_univ_four, hs32] at h
    linarith
  have h21 : G 2 1 = 0 := by
    rw [hs21, h12]
  have h31 : G 3 1 = 0 := by
    rw [hs31, h13]
  have h32 : G 3 2 = 0 := by
    rw [hs32, h23]
  have h22_eq_h11 : G 2 2 = G 1 1 := by
    have h := congrArg (fun M => M 1 2) (hRot 2)
    simp [rotMatrix, Matrix.mul_apply, Fin.sum_univ_four] at h
    linarith
  have h33_eq_h11 : G 3 3 = G 1 1 := by
    have h := congrArg (fun M => M 1 3) (hRot 1)
    simp [rotMatrix, Matrix.mul_apply, Fin.sum_univ_four] at h
    linarith
  refine ⟨G 0 0, G 1 1, ?_⟩
  ext a b
  fin_cases a <;> fin_cases b <;> simp [Matrix.diagonal]
  all_goals
    first
      | exact h01
      | exact h02
      | exact h03
      | exact h10
      | exact h12
      | exact h13
      | exact h20
      | exact h21
      | exact h22_eq_h11
      | exact h23
      | exact h30
      | exact h31
      | exact h32
      | exact h33_eq_h11

theorem spacetime_invariant_symmetric_form_scalar_of_kappa_ne_zero (κ : ℝ) (_hκ : κ ≠ 0)
    {G : RealSquareMatrix SpacetimeDim}
    (hG : isInvariantSymmetricSpacetimeForm κ G) :
    ∃ c : ℝ, G = c • spacetime_metric κ := by
  rcases hG with ⟨hSymm, hRot, hBoost⟩
  rcases rotation_invariant_symmetric_forms_shape G hSymm hRot with ⟨a, b, hdiag⟩
  have hrel : b = -κ * a := by
    have h := congrArg (fun M => M 0 1) (hBoost 0)
    simp [hdiag, boostMatrix, Matrix.mul_apply, Fin.sum_univ_four, Matrix.diagonal] at h
    linarith
  refine ⟨a, ?_⟩
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [hdiag, spacetime_metric_eq_diagonal, Matrix.diagonal, hrel, mul_comm]

theorem spacetime_invariant_symmetric_form_scalar_of_kappa_pos (κ : ℝ) (hκ : 0 < κ)
    {G : RealSquareMatrix SpacetimeDim}
    (hG : isInvariantSymmetricSpacetimeForm κ G) :
    ∃ c : ℝ, G = c • spacetime_metric κ := by
  exact spacetime_invariant_symmetric_form_scalar_of_kappa_ne_zero κ hκ.ne' hG

theorem galilean_invariant_symmetric_form_eq_dt2_scalar
    {G : RealSquareMatrix SpacetimeDim}
    (hG : isInvariantSymmetricSpacetimeForm 0 G) :
    ∃ c : ℝ, G = c • Matrix.diagonal ![1, 0, 0, 0] := by
  rcases hG with ⟨hSymm, hRot, hBoost⟩
  rcases rotation_invariant_symmetric_forms_shape G hSymm hRot with ⟨a, b, hdiag⟩
  have hb : b = 0 := by
    have h := congrArg (fun M => M 0 1) (hBoost 0)
    simp [hdiag, boostMatrix, Matrix.mul_apply, Fin.sum_univ_four, Matrix.diagonal] at h
    linarith
  refine ⟨a, ?_⟩
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [hdiag, Matrix.diagonal, hb]

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
  exact ⟨absoluteTimeCovector_bracket_zero (rotationGenerator 0 i),
    absoluteTimeCovector_bracket_zero (boostGenerator 0 i)⟩

theorem no_nonzero_invariant_covector_of_kappa_pos (κ : ℝ) (hκ : 0 < κ) :
    ∀ v : SpacetimeIndex → ℝ,
      (∀ i : SpatialIndex, ⁅boostGenerator κ i, v⁆ = 0) → v = 0 := by
  intro v hv
  have hvx : v 1 = 0 := by
    have h := congrArg (fun w => w 0) (hv 0)
    simpa [boostGenerator_bracket_eq] using h
  have hvy : v 2 = 0 := by
    have h := congrArg (fun w => w 0) (hv 1)
    simpa [boostGenerator_bracket_eq] using h
  have hvz : v 3 = 0 := by
    have h := congrArg (fun w => w 0) (hv 2)
    simpa [boostGenerator_bracket_eq] using h
  have htime : v 0 = 0 := by
    have h := congrArg (fun w => w 1) (hv 0)
    have hk0 : κ * v 0 = 0 := by
      simpa [boostGenerator_bracket_eq] using h
    exact (mul_eq_zero.mp hk0).resolve_left hκ.ne'
  ext a
  fin_cases a
  · exact htime
  · exact hvx
  · exact hvy
  · exact hvz

theorem absolute_time_line_not_invariant_of_kappa_pos (κ : ℝ) (hκ : 0 < κ) :
    ∃ i : SpatialIndex, ⁅boostGenerator κ i, absoluteTimeCovector⁆ ∉ (absoluteTimeLine : Set (SpacetimeIndex → ℝ)) := by
  refine ⟨0, ?_⟩
  intro hmem
  have hzero : ⁅boostGenerator κ 0, absoluteTimeCovector⁆ 1 = 0 := hmem.1
  have hcalc : ⁅boostGenerator κ 0, absoluteTimeCovector⁆ 1 = -κ := by
    simp [boostGenerator_bracket_eq, absoluteTimeCovector]
  linarith

theorem galilean_representation_metric :
    representationMetricMatrix 0 = Matrix.diagonal ![1, 0, 0, 0] := by
  rw [representationMetricMatrix, spacetime_metric_eq_diagonal]
  simp

theorem positive_kappa_suggests_lorentzian_behavior (κ : ℝ) (hκ : 0 < κ) :
    Matrix.transpose (lorentzCongruenceMatrix κ) * spacetime_metric κ * lorentzCongruenceMatrix κ =
      Matrix.diagonal ![1, -1, -1, -1] := by
  exact spacetime_metric_congruent_stdLorentz_of_kappa_pos κ hκ

end OnePostulate
