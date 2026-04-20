/-
Phase-1 kinematic algebra scaffolding.

This module uses an honest six-dimensional carrier. The explicit `4 x 4`
matrix realization stays primary, but it is a proof device rather than the
definition of the algebra itself.
-/
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.Lie.Matrix
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic
import OnePostulate.SpacetimeMatrices

namespace OnePostulate

abbrev KinematicAlgebra (_κ : ℝ) := AdjointIndex → ℝ

def basisCoordinate : AdjointIndex → KinematicAlgebra κ :=
  fun a b => if b = a then 1 else 0

@[simp] theorem basisCoordinate_apply_self (a : AdjointIndex) :
    basisCoordinate (κ := κ) a a = 1 := by
  simp [basisCoordinate]

@[simp] theorem basisCoordinate_apply_ne {a b : AdjointIndex} (h : b ≠ a) :
    basisCoordinate (κ := κ) a b = 0 := by
  simp [basisCoordinate, h]

def rotationGenerator (κ : ℝ) (i : SpatialIndex) : KinematicAlgebra κ :=
  basisCoordinate (κ := κ) (rotationIndex i)

def boostGenerator (κ : ℝ) (i : SpatialIndex) : KinematicAlgebra κ :=
  basisCoordinate (κ := κ) (boostIndex i)

def basisGenerator (κ : ℝ) : BasisTag → KinematicAlgebra κ
  | BasisTag.rotation i => rotationGenerator κ i
  | BasisTag.boost i => boostGenerator κ i

def basisMatrix (κ : ℝ) : AdjointIndex → RealSquareMatrix SpacetimeDim
  | 0 => rotMatrix 0
  | 1 => rotMatrix 1
  | 2 => rotMatrix 2
  | 3 => boostMatrix κ 0
  | 4 => boostMatrix κ 1
  | _ => boostMatrix κ 2

@[simp] theorem basisMatrix_rotationIndex (κ : ℝ) (i : SpatialIndex) :
    basisMatrix κ (rotationIndex i) = rotMatrix i := by
  fin_cases i <;> rfl

@[simp] theorem basisMatrix_boostIndex (κ : ℝ) (i : SpatialIndex) :
    basisMatrix κ (boostIndex i) = boostMatrix κ i := by
  fin_cases i <;> rfl

noncomputable def kinematicToMatrix (κ : ℝ) :
    KinematicAlgebra κ →ₗ[ℝ] RealSquareMatrix SpacetimeDim where
  toFun x := ∑ a : AdjointIndex, x a • basisMatrix κ a
  map_add' x y := by
    simp [Finset.sum_add_distrib, add_smul]
  map_smul' t x := by
    calc
      ∑ a : AdjointIndex, (t * x a) • basisMatrix κ a
          = ∑ a : AdjointIndex, t • (x a • basisMatrix κ a) := by
              simp [smul_smul]
      _ = t • ∑ a : AdjointIndex, x a • basisMatrix κ a := by
            rw [Finset.smul_sum]

def matrixToKinematic (_κ : ℝ) (M : RealSquareMatrix SpacetimeDim) : KinematicAlgebra κ
  | 0 => M 3 2
  | 1 => M 1 3
  | 2 => M 2 1
  | 3 => M 1 0
  | 4 => M 2 0
  | _ => M 3 0

@[simp] theorem kinematicToMatrix_basisCoordinate (κ : ℝ) (a : AdjointIndex) :
    kinematicToMatrix κ (basisCoordinate (κ := κ) a) = basisMatrix κ a := by
  change ∑ b : AdjointIndex, (if b = a then 1 else 0) • basisMatrix κ b = basisMatrix κ a
  simpa [eq_comm] using (Finset.sum_ite_eq' Finset.univ a (fun b => basisMatrix κ b))

@[simp] theorem kinematicToMatrix_rotationGenerator (κ : ℝ) (i : SpatialIndex) :
    kinematicToMatrix κ (rotationGenerator κ i) = rotMatrix i := by
  simpa [rotationGenerator] using kinematicToMatrix_basisCoordinate κ (rotationIndex i)

@[simp] theorem kinematicToMatrix_boostGenerator (κ : ℝ) (i : SpatialIndex) :
    kinematicToMatrix κ (boostGenerator κ i) = boostMatrix κ i := by
  simpa [boostGenerator] using kinematicToMatrix_basisCoordinate κ (boostIndex i)

@[simp] theorem matrixToKinematic_kinematicToMatrix (κ : ℝ) (x : KinematicAlgebra κ) :
    matrixToKinematic κ (kinematicToMatrix κ x) = x := by
  ext a
  fin_cases a <;>
    simp [matrixToKinematic, kinematicToMatrix, basisMatrix, Fin.sum_univ_six, rotMatrix, boostMatrix] <;>
    rfl

theorem kinematicToMatrix_injective (κ : ℝ) :
    Function.Injective (kinematicToMatrix κ) := by
  intro x y hxy
  rw [← matrixToKinematic_kinematicToMatrix κ x, hxy, matrixToKinematic_kinematicToMatrix]

private theorem matrixBracket_skew (A B : RealSquareMatrix SpacetimeDim) :
    matrixBracket A B = -matrixBracket B A := by
  ext i j
  simp [matrixBracket]

theorem matrix_bracket_KJ (κ : ℝ) (i j : SpatialIndex) :
    matrixBracket (boostMatrix κ i) (rotMatrix j) =
      ∑ k : SpatialIndex, (-(leviCivita j i k : ℝ)) • boostMatrix κ k := by
  calc
    matrixBracket (boostMatrix κ i) (rotMatrix j)
        = -matrixBracket (rotMatrix j) (boostMatrix κ i) := by
            simpa using matrixBracket_skew (boostMatrix κ i) (rotMatrix j)
    _ = -(∑ k : SpatialIndex, (leviCivita j i k : ℝ) • boostMatrix κ k) := by
          rw [matrix_bracket_JK]
    _ = ∑ k : SpatialIndex, (-(leviCivita j i k : ℝ)) • boostMatrix κ k := by
          simp [Finset.sum_neg_distrib]

def basisBracket (κ : ℝ) : AdjointIndex → AdjointIndex → KinematicAlgebra κ
  | a, b =>
      match basisTagOfIndex a, basisTagOfIndex b with
      | BasisTag.rotation i, BasisTag.rotation j =>
          ∑ k : SpatialIndex, (leviCivita i j k : ℝ) • rotationGenerator κ k
      | BasisTag.rotation i, BasisTag.boost j =>
          ∑ k : SpatialIndex, (leviCivita i j k : ℝ) • boostGenerator κ k
      | BasisTag.boost i, BasisTag.rotation j =>
          ∑ k : SpatialIndex, (-(leviCivita j i k : ℝ)) • boostGenerator κ k
      | BasisTag.boost i, BasisTag.boost j =>
          ∑ k : SpatialIndex, (-(κ : ℝ) * (leviCivita i j k : ℝ)) • rotationGenerator κ k

noncomputable def kinematicBracket (κ : ℝ) (x y : KinematicAlgebra κ) : KinematicAlgebra κ :=
  ∑ a : AdjointIndex, ∑ b : AdjointIndex, (x a * y b) • basisBracket κ a b

noncomputable instance instBracketKinematicAlgebra (κ : ℝ) :
    Bracket (KinematicAlgebra κ) (KinematicAlgebra κ) where
  bracket := kinematicBracket κ

set_option maxHeartbeats 0 in
theorem kinematicToMatrix_basisBracket (κ : ℝ) (a b : AdjointIndex) :
    kinematicToMatrix κ (basisBracket κ a b) =
      matrixBracket (basisMatrix κ a) (basisMatrix κ b) := by
  cases hta : basisTagOfIndex a with
  | rotation i =>
      cases htb : basisTagOfIndex b with
      | rotation j =>
          have ha : a = rotationIndex i := by
            simpa using congrArg indexOfBasisTag hta
          have hb : b = rotationIndex j := by
            simpa using congrArg indexOfBasisTag htb
          subst a
          subst b
          simpa [basisBracket, map_sum] using (matrix_bracket_JJ i j).symm
      | boost j =>
          have ha : a = rotationIndex i := by
            simpa using congrArg indexOfBasisTag hta
          have hb : b = boostIndex j := by
            simpa using congrArg indexOfBasisTag htb
          subst a
          subst b
          simpa [basisBracket, map_sum] using (matrix_bracket_JK κ i j).symm
  | boost i =>
      cases htb : basisTagOfIndex b with
      | rotation j =>
          have ha : a = boostIndex i := by
            simpa using congrArg indexOfBasisTag hta
          have hb : b = rotationIndex j := by
            simpa using congrArg indexOfBasisTag htb
          subst a
          subst b
          simpa [basisBracket, map_sum] using (matrix_bracket_KJ κ i j).symm
      | boost j =>
          have ha : a = boostIndex i := by
            simpa using congrArg indexOfBasisTag hta
          have hb : b = boostIndex j := by
            simpa using congrArg indexOfBasisTag htb
          subst a
          subst b
          simpa [basisBracket, map_sum] using (matrix_bracket_KK κ i j).symm

private theorem kinematicToMatrix_mul (κ : ℝ) (x y : KinematicAlgebra κ) :
    kinematicToMatrix κ x * kinematicToMatrix κ y =
      ∑ a : AdjointIndex, ∑ b : AdjointIndex, (x a * y b) • (basisMatrix κ a * basisMatrix κ b) := by
  calc
    kinematicToMatrix κ x * kinematicToMatrix κ y
        = (∑ a : AdjointIndex, x a • basisMatrix κ a) *
            (∑ b : AdjointIndex, y b • basisMatrix κ b) := rfl
    _ = ∑ a : AdjointIndex, (x a • basisMatrix κ a) *
          (∑ b : AdjointIndex, y b • basisMatrix κ b) := by
          rw [Finset.sum_mul]
    _ = ∑ a : AdjointIndex, ∑ b : AdjointIndex,
          (x a • basisMatrix κ a) * (y b • basisMatrix κ b) := by
          refine Finset.sum_congr rfl ?_
          intro a ha
          rw [Finset.mul_sum]
    _ = ∑ a : AdjointIndex, ∑ b : AdjointIndex,
          (x a * y b) • (basisMatrix κ a * basisMatrix κ b) := by
          refine Finset.sum_congr rfl ?_
          intro a ha
          refine Finset.sum_congr rfl ?_
          intro b hb
          rw [smul_mul_assoc, mul_smul_comm, smul_smul]

set_option maxHeartbeats 0 in
theorem kinematicToMatrix_lie (κ : ℝ) (x y : KinematicAlgebra κ) :
    kinematicToMatrix κ ⁅x, y⁆ =
      matrixBracket (kinematicToMatrix κ x) (kinematicToMatrix κ y) := by
  calc
    kinematicToMatrix κ ⁅x, y⁆
        = ∑ a : AdjointIndex, ∑ b : AdjointIndex,
            (x a * y b) • matrixBracket (basisMatrix κ a) (basisMatrix κ b) := by
            change kinematicToMatrix κ (kinematicBracket κ x y) = _
            rw [kinematicBracket]
            simp_rw [map_sum, map_smul, kinematicToMatrix_basisBracket]
    _ = (∑ a : AdjointIndex, ∑ b : AdjointIndex,
            (x a * y b) • (basisMatrix κ a * basisMatrix κ b)) -
          (∑ a : AdjointIndex, ∑ b : AdjointIndex,
            (x a * y b) • (basisMatrix κ b * basisMatrix κ a)) := by
            simp [matrixBracket, smul_sub, Finset.sum_sub_distrib]
    _ = kinematicToMatrix κ x * kinematicToMatrix κ y -
          kinematicToMatrix κ y * kinematicToMatrix κ x := by
          rw [kinematicToMatrix_mul, kinematicToMatrix_mul]
          congr 1
          rw [Finset.sum_comm]
          refine Finset.sum_congr rfl ?_
          intro a ha
          refine Finset.sum_congr rfl ?_
          intro b hb
          rw [mul_comm]

set_option maxHeartbeats 0 in
noncomputable instance instLieRingKinematicAlgebra (κ : ℝ) : LieRing (KinematicAlgebra κ) where
  add_lie x y z := by
    apply kinematicToMatrix_injective κ
    rw [map_add, kinematicToMatrix_lie, kinematicToMatrix_lie, kinematicToMatrix_lie]
    simp [matrixBracket]
    noncomm_ring
  lie_add x y z := by
    apply kinematicToMatrix_injective κ
    rw [map_add, kinematicToMatrix_lie, kinematicToMatrix_lie, kinematicToMatrix_lie]
    simp [matrixBracket]
    noncomm_ring
  lie_self x := by
    apply kinematicToMatrix_injective κ
    simp [kinematicToMatrix_lie, matrixBracket]
  leibniz_lie x y z := by
    apply kinematicToMatrix_injective κ
    rw [kinematicToMatrix_lie, map_add]
    repeat rw [kinematicToMatrix_lie]
    simp [matrixBracket]
    noncomm_ring

set_option maxHeartbeats 0 in
noncomputable instance instLieAlgebraKinematicAlgebra (κ : ℝ) : LieAlgebra ℝ (KinematicAlgebra κ) where
  lie_smul t x y := by
    apply kinematicToMatrix_injective κ
    rw [map_smul, kinematicToMatrix_lie, kinematicToMatrix_lie]
    simp [matrixBracket, smul_sub]

theorem kinematic_bracket_table (κ : ℝ) :
    (∀ i j : SpatialIndex,
        ⁅rotationGenerator κ i, rotationGenerator κ j⁆ =
          ∑ k : SpatialIndex, (leviCivita i j k : ℝ) • rotationGenerator κ k) ∧
    (∀ i j : SpatialIndex,
        ⁅rotationGenerator κ i, boostGenerator κ j⁆ =
          ∑ k : SpatialIndex, (leviCivita i j k : ℝ) • boostGenerator κ k) ∧
    (∀ i j : SpatialIndex,
        ⁅boostGenerator κ i, boostGenerator κ j⁆ =
          ∑ k : SpatialIndex, (-(κ : ℝ) * (leviCivita i j k : ℝ)) • rotationGenerator κ k) := by
  constructor
  · intro i j
    apply kinematicToMatrix_injective κ
    simpa [kinematicToMatrix_lie, map_sum] using matrix_bracket_JJ i j
  constructor
  · intro i j
    apply kinematicToMatrix_injective κ
    simpa [kinematicToMatrix_lie, map_sum] using matrix_bracket_JK κ i j
  · intro i j
    apply kinematicToMatrix_injective κ
    simpa [kinematicToMatrix_lie, map_sum] using matrix_bracket_KK κ i j

theorem kinematic_bracket_jacobi (κ : ℝ) (x y z : KinematicAlgebra κ) :
    ⁅x, ⁅y, z⁆⁆ = ⁅⁅x, y⁆, z⁆ + ⁅y, ⁅x, z⁆⁆ := by
  exact (instLieRingKinematicAlgebra κ).leibniz_lie x y z

def boostCommutatorMatrix (κ : ℝ) : RealSquareMatrix SpatialDim :=
  Matrix.diagonal ![-κ, -κ, -κ]

def adjointTraceModel (κ : ℝ) : RealSquareMatrix AdjointDim :=
  Matrix.diagonal ![-4, -4, -4, 4 * κ, 4 * κ, 4 * κ]

theorem boostCommutator_scales_with_kappa (κ : ℝ) :
    boostCommutatorMatrix κ 0 0 = -κ := by
  simp [boostCommutatorMatrix]

theorem adjointTraceModel_matches_paper_shape (κ : ℝ) :
    adjointTraceModel κ 3 3 = 4 * κ := by
  simp [adjointTraceModel]

end OnePostulate
