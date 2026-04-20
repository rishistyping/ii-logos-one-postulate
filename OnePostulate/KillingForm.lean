/-
Phase-1 Killing form skeleton.

This file takes the explicit computational route first. We write down the six
adjoint matrices in the ordered basis `(Jx, Jy, Jz, Kx, Ky, Kz)`, define the
Killing entries using `Matrix.trace`, and only then package the resulting
diagonal form. This keeps a later comparison to Mathlib's abstract
`killingForm` straightforward.
-/
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.Lie.Killing
import Mathlib.Data.Fin.VecNotation
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic
import OnePostulate.KinematicAlgebra

namespace OnePostulate

def adjointBasisTag : AdjointIndex → BasisTag
  | 0 => BasisTag.rotation 0
  | 1 => BasisTag.rotation 1
  | 2 => BasisTag.rotation 2
  | 3 => BasisTag.boost 0
  | 4 => BasisTag.boost 1
  | _ => BasisTag.boost 2

@[simp] theorem adjointBasisTag_rotationIndex (i : SpatialIndex) :
    adjointBasisTag (rotationIndex i) = BasisTag.rotation i := by
  fin_cases i <;> rfl

@[simp] theorem adjointBasisTag_boostIndex (i : SpatialIndex) :
    adjointBasisTag (boostIndex i) = BasisTag.boost i := by
  fin_cases i <;> rfl

/-- Explicit adjoint matrices for the ordered basis `(Jx, Jy, Jz, Kx, Ky, Kz)`. -/
def adjointMatrix (κ : ℝ) : BasisTag → RealSquareMatrix AdjointDim
  | BasisTag.rotation 0 =>
      !![0, 0, 0, 0, 0, 0;
         0, 0, -1, 0, 0, 0;
         0, 1, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, -1;
         0, 0, 0, 0, 1, 0]
  | BasisTag.rotation 1 =>
      !![0, 0, 1, 0, 0, 0;
         0, 0, 0, 0, 0, 0;
         -1, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 1;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, -1, 0, 0]
  | BasisTag.rotation _ =>
      !![0, -1, 0, 0, 0, 0;
         1, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, -1, 0;
         0, 0, 0, 1, 0, 0;
         0, 0, 0, 0, 0, 0]
  | BasisTag.boost 0 =>
      !![0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, κ;
         0, 0, 0, 0, -κ, 0;
         0, 0, 0, 0, 0, 0;
         0, 0, -1, 0, 0, 0;
         0, 1, 0, 0, 0, 0]
  | BasisTag.boost 1 =>
      !![0, 0, 0, 0, 0, -κ;
         0, 0, 0, 0, 0, 0;
         0, 0, 0, κ, 0, 0;
         0, 0, 1, 0, 0, 0;
         0, 0, 0, 0, 0, 0;
         -1, 0, 0, 0, 0, 0]
  | BasisTag.boost _ =>
      !![0, 0, 0, 0, κ, 0;
         0, 0, 0, -κ, 0, 0;
         0, 0, 0, 0, 0, 0;
         0, -1, 0, 0, 0, 0;
         1, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0]

def killingFormEntry (κ : ℝ) (x y : BasisTag) : ℝ :=
  Matrix.trace (adjointMatrix κ x * adjointMatrix κ y)

def rotationKillingBlock : RealSquareMatrix SpatialDim :=
  fun i j => killingFormEntry 0 (BasisTag.rotation i) (BasisTag.rotation j)

def boostKillingBlock (κ : ℝ) : RealSquareMatrix SpatialDim :=
  fun i j => killingFormEntry κ (BasisTag.boost i) (BasisTag.boost j)

def killingFormMatrix (κ : ℝ) : RealSquareMatrix AdjointDim :=
  fun i j => killingFormEntry κ (adjointBasisTag i) (adjointBasisTag j)

set_option maxHeartbeats 0 in
theorem killing_form_diag (κ : ℝ) :
    killingFormMatrix κ = Matrix.diagonal ![-4, -4, -4, 4 * κ, 4 * κ, 4 * κ] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [killingFormMatrix, killingFormEntry, adjointBasisTag, adjointMatrix,
      Matrix.trace, Fin.sum_univ_six] <;>
    ring

set_option maxHeartbeats 0 in
theorem boost_killing_form_eq (κ : ℝ) :
    boostKillingBlock κ = Matrix.diagonal ![4 * κ, 4 * κ, 4 * κ] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [boostKillingBlock, killingFormEntry, adjointMatrix, Matrix.trace, Fin.sum_univ_six] <;>
    ring

theorem boost_killing_nondegenerate_iff_kappa_ne_zero (κ : ℝ) :
    Matrix.Nondegenerate (boostKillingBlock κ) ↔ κ ≠ 0 := by
  rw [Matrix.nondegenerate_iff_det_ne_zero, boost_killing_form_eq, Matrix.det_diagonal,
    Fin.prod_univ_three]
  constructor
  · intro hdet hκ
    apply hdet
    simp [hκ]
  · intro hκ
    have hk : (4 * κ : ℝ) ≠ 0 := mul_ne_zero (by norm_num) hκ
    exact mul_ne_zero (mul_ne_zero hk hk) hk

theorem boostKillingBlock_entry (κ : ℝ) :
    boostKillingBlock κ 0 0 = 4 * κ := by
  exact congrArg (fun M => M 0 0) (boost_killing_form_eq κ)

theorem killingFormMatrix_has_expected_diagonal_shape (κ : ℝ) :
    killingFormMatrix κ = Matrix.diagonal ![-4, -4, -4, 4 * κ, 4 * κ, 4 * κ] := by
  exact killing_form_diag κ

theorem killingFormMatrix_matches_adjoint_trace_model (κ : ℝ) :
    killingFormMatrix κ = adjointTraceModel κ := by
  simpa [adjointTraceModel] using killing_form_diag κ

theorem basisCoordinate_eq_pi_basisFun (κ : ℝ) (a : AdjointIndex) :
    basisCoordinate (κ := κ) a = Pi.basisFun ℝ AdjointIndex a := by
  ext b
  by_cases h : b = a
  · subst h
    simp [basisCoordinate]
  · simp [basisCoordinate, Pi.basisFun_apply, h]

set_option maxHeartbeats 0 in
theorem adjointMatrix_rotation_rotation_column (κ : ℝ) (i j : SpatialIndex) :
    ∑ k : SpatialIndex, (leviCivita i j k : ℝ) • rotationGenerator κ k =
      fun c => adjointMatrix κ (BasisTag.rotation i) c (rotationIndex j) := by
  ext c
  fin_cases i <;> fin_cases j <;> fin_cases c <;>
    simp [rotationGenerator, basisCoordinate, adjointMatrix, rotationIndex,
      Fin.sum_univ_three, leviCivita]

set_option maxHeartbeats 0 in
theorem adjointMatrix_rotation_boost_column (κ : ℝ) (i j : SpatialIndex) :
    ∑ k : SpatialIndex, (leviCivita i j k : ℝ) • boostGenerator κ k =
      fun c => adjointMatrix κ (BasisTag.rotation i) c (boostIndex j) := by
  ext c
  fin_cases i <;> fin_cases j <;> fin_cases c <;>
    simp [boostGenerator, basisCoordinate, adjointMatrix, boostIndex,
      Fin.sum_univ_three, leviCivita]

set_option maxHeartbeats 0 in
theorem adjointMatrix_boost_rotation_column (κ : ℝ) (i j : SpatialIndex) :
    ∑ k : SpatialIndex, (-(leviCivita j i k : ℝ)) • boostGenerator κ k =
      fun c => adjointMatrix κ (BasisTag.boost i) c (rotationIndex j) := by
  ext c
  fin_cases i <;> fin_cases j <;> fin_cases c <;>
    simp [boostGenerator, basisCoordinate, adjointMatrix, rotationIndex, boostIndex,
      Fin.sum_univ_three, leviCivita]

set_option maxHeartbeats 0 in
theorem adjointMatrix_boost_boost_column (κ : ℝ) (i j : SpatialIndex) :
    ∑ k : SpatialIndex, (-(κ : ℝ) * (leviCivita i j k : ℝ)) • rotationGenerator κ k =
      fun c => adjointMatrix κ (BasisTag.boost i) c (boostIndex j) := by
  ext c
  fin_cases i <;> fin_cases j <;> fin_cases c <;>
    simp [rotationGenerator, basisCoordinate, adjointMatrix, rotationIndex, boostIndex,
      Fin.sum_univ_three, leviCivita]

theorem basisCoordinate_bracket_apply (κ : ℝ) (a b c : AdjointIndex) :
    ⁅basisCoordinate (κ := κ) a, basisCoordinate (κ := κ) b⁆ c =
      adjointMatrix κ (adjointBasisTag a) c b := by
  cases hta : basisTagOfIndex a with
  | rotation i =>
      have ha : a = rotationIndex i := by
        simpa using congrArg indexOfBasisTag hta
      subst a
      cases htb : basisTagOfIndex b with
      | rotation j =>
          have hb : b = rotationIndex j := by
            simpa using congrArg indexOfBasisTag htb
          subst b
          rcases kinematic_bracket_table κ with ⟨hJJ, _, _⟩
          calc
            ⁅basisCoordinate (κ := κ) (rotationIndex i),
                basisCoordinate (κ := κ) (rotationIndex j)⁆ c
                = (∑ k : SpatialIndex, (leviCivita i j k : ℝ) • rotationGenerator κ k) c := by
                    simpa [rotationGenerator] using congrArg (fun x => x c) (hJJ i j)
            _ = adjointMatrix κ (adjointBasisTag (rotationIndex i)) c (rotationIndex j) := by
                    simpa using congrArg (fun x => x c)
                      (adjointMatrix_rotation_rotation_column κ i j)
      | boost j =>
          have hb : b = boostIndex j := by
            simpa using congrArg indexOfBasisTag htb
          subst b
          rcases kinematic_bracket_table κ with ⟨_, hJK, _⟩
          calc
            ⁅basisCoordinate (κ := κ) (rotationIndex i),
                basisCoordinate (κ := κ) (boostIndex j)⁆ c
                = (∑ k : SpatialIndex, (leviCivita i j k : ℝ) • boostGenerator κ k) c := by
                    simpa [rotationGenerator, boostGenerator] using
                      congrArg (fun x => x c) (hJK i j)
            _ = adjointMatrix κ (adjointBasisTag (rotationIndex i)) c (boostIndex j) := by
                    simpa using congrArg (fun x => x c)
                      (adjointMatrix_rotation_boost_column κ i j)
  | boost i =>
      have ha : a = boostIndex i := by
        simpa using congrArg indexOfBasisTag hta
      subst a
      cases htb : basisTagOfIndex b with
      | rotation j =>
          have hb : b = rotationIndex j := by
            simpa using congrArg indexOfBasisTag htb
          subst b
          rcases kinematic_bracket_table κ with ⟨_, hJK, _⟩
          have hKJ : ⁅boostGenerator κ i, rotationGenerator κ j⁆ =
              ∑ k : SpatialIndex, (-(leviCivita j i k : ℝ)) • boostGenerator κ k := by
            calc
              ⁅boostGenerator κ i, rotationGenerator κ j⁆ =
                  -⁅rotationGenerator κ j, boostGenerator κ i⁆ := by
                    exact (lie_skew (boostGenerator κ i) (rotationGenerator κ j)).symm
              _ = -(∑ k : SpatialIndex, (leviCivita j i k : ℝ) • boostGenerator κ k) := by
                    rw [hJK j i]
              _ = ∑ k : SpatialIndex, (-(leviCivita j i k : ℝ)) • boostGenerator κ k := by
                    simp [Finset.sum_neg_distrib]
          calc
            ⁅basisCoordinate (κ := κ) (boostIndex i),
                basisCoordinate (κ := κ) (rotationIndex j)⁆ c
                = (∑ k : SpatialIndex, (-(leviCivita j i k : ℝ)) • boostGenerator κ k) c := by
                    simpa [rotationGenerator, boostGenerator] using
                      congrArg (fun x => x c) hKJ
            _ = adjointMatrix κ (adjointBasisTag (boostIndex i)) c (rotationIndex j) := by
                    simpa using congrArg (fun x => x c)
                      (adjointMatrix_boost_rotation_column κ i j)
      | boost j =>
          have hb : b = boostIndex j := by
            simpa using congrArg indexOfBasisTag htb
          subst b
          rcases kinematic_bracket_table κ with ⟨_, _, hKK⟩
          calc
            ⁅basisCoordinate (κ := κ) (boostIndex i),
                basisCoordinate (κ := κ) (boostIndex j)⁆ c
                = (∑ k : SpatialIndex, (-(κ : ℝ) * (leviCivita i j k : ℝ)) •
                    rotationGenerator κ k) c := by
                    simpa [boostGenerator, rotationGenerator] using
                      congrArg (fun x => x c) (hKK i j)
            _ = adjointMatrix κ (adjointBasisTag (boostIndex i)) c (boostIndex j) := by
                    simpa using congrArg (fun x => x c)
                      (adjointMatrix_boost_boost_column κ i j)

set_option maxHeartbeats 0 in
theorem toMatrix_ad_basisCoordinate_eq_adjointMatrix (κ : ℝ) (a : AdjointIndex) :
    LinearMap.toMatrix (Pi.basisFun ℝ AdjointIndex) (Pi.basisFun ℝ AdjointIndex)
      (LieAlgebra.ad ℝ (KinematicAlgebra κ) (basisCoordinate (κ := κ) a)) =
        adjointMatrix κ (adjointBasisTag a) := by
  ext i j
  rw [LinearMap.toMatrix_apply, Pi.basisFun_repr, ← basisCoordinate_eq_pi_basisFun κ j,
    LieAlgebra.ad_apply]
  simpa using basisCoordinate_bracket_apply κ a j i

theorem mathlib_killingForm_eq_explicit_on_basis (κ : ℝ) (a b : AdjointIndex) :
    killingForm ℝ (KinematicAlgebra κ)
        (basisCoordinate (κ := κ) a) (basisCoordinate (κ := κ) b) =
      killingFormMatrix κ a b := by
  rw [killingForm_apply_apply, LinearMap.trace_eq_matrix_trace ℝ (Pi.basisFun ℝ AdjointIndex)]
  change Matrix.trace
      (LinearMap.toMatrix (Pi.basisFun ℝ AdjointIndex) (Pi.basisFun ℝ AdjointIndex)
          ((LieAlgebra.ad ℝ (KinematicAlgebra κ) (basisCoordinate (κ := κ) a)) *
            (LieAlgebra.ad ℝ (KinematicAlgebra κ) (basisCoordinate (κ := κ) b)))) =
    killingFormMatrix κ a b
  rw [LinearMap.toMatrix_mul, toMatrix_ad_basisCoordinate_eq_adjointMatrix,
    toMatrix_ad_basisCoordinate_eq_adjointMatrix]
  rfl

end OnePostulate
