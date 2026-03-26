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
  sorry

@[simp] theorem kinematicToMatrix_rotationGenerator (κ : ℝ) (i : SpatialIndex) :
    kinematicToMatrix κ (rotationGenerator κ i) = rotMatrix i := by
  sorry

@[simp] theorem kinematicToMatrix_boostGenerator (κ : ℝ) (i : SpatialIndex) :
    kinematicToMatrix κ (boostGenerator κ i) = boostMatrix κ i := by
  sorry

@[simp] theorem matrixToKinematic_kinematicToMatrix (κ : ℝ) (x : KinematicAlgebra κ) :
    matrixToKinematic κ (kinematicToMatrix κ x) = x := by
  sorry

theorem kinematicToMatrix_injective (κ : ℝ) :
    Function.Injective (kinematicToMatrix κ) := by
  sorry

theorem matrix_bracket_KJ (κ : ℝ) (i j : SpatialIndex) :
    matrixBracket (boostMatrix κ i) (rotMatrix j) =
      ∑ k : SpatialIndex, (-(leviCivita j i k : ℝ)) • boostMatrix κ k := by
  sorry

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
  sorry

private theorem kinematicToMatrix_mul (κ : ℝ) (x y : KinematicAlgebra κ) :
    kinematicToMatrix κ x * kinematicToMatrix κ y =
      ∑ a : AdjointIndex, ∑ b : AdjointIndex, (x a * y b) • (basisMatrix κ a * basisMatrix κ b) := by
  sorry

set_option maxHeartbeats 0 in
theorem kinematicToMatrix_lie (κ : ℝ) (x y : KinematicAlgebra κ) :
    kinematicToMatrix κ ⁅x, y⁆ =
      matrixBracket (kinematicToMatrix κ x) (kinematicToMatrix κ y) := by
  sorry

noncomputable instance instLieRingKinematicAlgebra (κ : ℝ) : LieRing (KinematicAlgebra κ) where
  add_lie x y z := by
    sorry
  lie_add x y z := by
    sorry
  lie_self x := by
    sorry
  leibniz_lie x y z := by
    sorry

noncomputable instance instLieAlgebraKinematicAlgebra (κ : ℝ) : LieAlgebra ℝ (KinematicAlgebra κ) where
  lie_smul t x y := by
    sorry

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
  exact leibniz_lie x y z

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
