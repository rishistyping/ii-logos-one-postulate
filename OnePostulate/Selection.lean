/-
Selection layer for phase 1.

This is the thin interface that states the branch-selection conclusions used by
the rest of the development while heavier proofs remain deferred.
-/
import OnePostulate.SpacetimeRepresentation

namespace OnePostulate

noncomputable def preferredBranch (κ : ℝ) : Branch :=
  classifyKappa κ

theorem positive_kappa_selects_lorentz (κ : ℝ) (hκ : 0 < κ) :
    preferredBranch κ = Branch.lorentz := by
  simp [preferredBranch, classifyKappa, hκ]

theorem zero_kappa_selects_galilean :
    preferredBranch 0 = Branch.galilean := by
  simp [preferredBranch, classifyKappa]

theorem negative_kappa_selects_euclidean (κ : ℝ) (hκ : κ < 0) :
    preferredBranch κ = Branch.euclidean := by
  have hnot : ¬ 0 < κ := not_lt.mpr hκ.le
  simp [preferredBranch, classifyKappa, hnot, hκ.ne]

theorem negative_kappa_no_nonzero_null_vectors (κ : ℝ) (hκ : κ < 0) :
    ∀ v : SpacetimeIndex → ℝ,
      v ≠ 0 → dotProduct v (Matrix.mulVec (spacetime_metric κ) v) ≠ 0 := by
  intro v hv
  have hcoords : v 0 ≠ 0 ∨ v 1 ≠ 0 ∨ v 2 ≠ 0 ∨ v 3 ≠ 0 := by
    by_cases h0 : v 0 = 0
    · by_cases h1 : v 1 = 0
      · by_cases h2 : v 2 = 0
        · by_cases h3 : v 3 = 0
          · exfalso
            have hvzero : v = 0 := by
              ext i
              fin_cases i
              · exact h0
              · exact h1
              · exact h2
              · exact h3
            exact hv hvzero
          · exact Or.inr <| Or.inr <| Or.inr h3
        · exact Or.inr <| Or.inr <| Or.inl h2
      · exact Or.inr <| Or.inl h1
    · exact Or.inl h0
  have hform :
      dotProduct v (Matrix.mulVec (spacetime_metric κ) v) =
        (v 0)^2 - κ * ((v 1)^2 + (v 2)^2 + (v 3)^2) := by
    simp [spacetime_metric, spacetimeMetricMatrix, Matrix.mulVec, dotProduct, Fin.sum_univ_four]
    ring_nf
  have hkpos : 0 < -κ := by linarith
  rcases hcoords with h0 | h1 | h2 | h3
  · have hs : 0 < (v 0)^2 := sq_pos_of_ne_zero h0
    have hpos :
        0 < (v 0)^2 - κ * ((v 1)^2 + (v 2)^2 + (v 3)^2) := by
      nlinarith [hs, hkpos, sq_nonneg (v 1), sq_nonneg (v 2), sq_nonneg (v 3)]
    exact ne_of_gt (by simpa [hform] using hpos)
  · have hs : 0 < (v 1)^2 := sq_pos_of_ne_zero h1
    have hpos :
        0 < (v 0)^2 - κ * ((v 1)^2 + (v 2)^2 + (v 3)^2) := by
      nlinarith [sq_nonneg (v 0), hs, hkpos, sq_nonneg (v 2), sq_nonneg (v 3)]
    exact ne_of_gt (by simpa [hform] using hpos)
  · have hs : 0 < (v 2)^2 := sq_pos_of_ne_zero h2
    have hpos :
        0 < (v 0)^2 - κ * ((v 1)^2 + (v 2)^2 + (v 3)^2) := by
      nlinarith [sq_nonneg (v 0), sq_nonneg (v 1), hs, hkpos, sq_nonneg (v 3)]
    exact ne_of_gt (by simpa [hform] using hpos)
  · have hs : 0 < (v 3)^2 := sq_pos_of_ne_zero h3
    have hpos :
        0 < (v 0)^2 - κ * ((v 1)^2 + (v 2)^2 + (v 3)^2) := by
      nlinarith [sq_nonneg (v 0), sq_nonneg (v 1), sq_nonneg (v 2), hs, hkpos]
    exact ne_of_gt (by simpa [hform] using hpos)

theorem positive_kappa_gives_finite_real_invariant_speed (κ : ℝ) (hκ : 0 < κ) :
    0 < invariantSpeedSquared κ ∧
      ∃ c : ℝ, 0 < c ∧ c^2 = invariantSpeedSquared κ := by
  have hs : 0 < invariantSpeedSquared κ := by
    rw [invariantSpeedSquared_formula]
    exact inv_pos.mpr hκ
  refine ⟨hs, ?_⟩
  refine ⟨Real.sqrt (invariantSpeedSquared κ), Real.sqrt_pos.mpr hs, ?_⟩
  simpa [pow_two] using (Real.sq_sqrt hs.le)

theorem selection_of_positive_kappa (κ : ℝ) (hκ : 0 < κ) :
    preferredBranch κ = Branch.lorentz ∧
      Matrix.Nondegenerate (velocityMetricMatrix κ) ∧
      Matrix.transpose (lorentzCongruenceMatrix κ) * spacetime_metric κ *
          lorentzCongruenceMatrix κ = Matrix.diagonal ![1, -1, -1, -1] ∧
      0 < invariantSpeedSquared κ ∧
      (∃ c : ℝ, 0 < c ∧ c^2 = invariantSpeedSquared κ) ∧
      (∀ v : SpacetimeIndex → ℝ, (∀ i : SpatialIndex, ⁅boostGenerator κ i, v⁆ = 0) → v = 0) ∧
      (∃ i : SpatialIndex, ⁅boostGenerator κ i, absoluteTimeCovector⁆ ∉
        (absoluteTimeLine : Set (SpacetimeIndex → ℝ))) := by
  rcases positive_kappa_gives_finite_real_invariant_speed κ hκ with ⟨hspeed, hspeedWitness⟩
  refine ⟨positive_kappa_selects_lorentz κ hκ, ?_, ?_, hspeed, hspeedWitness, ?_, ?_⟩
  · have hdet : (velocityMetricMatrix κ).det ≠ 0 := by
      rw [killing_restricts_to_metric, Matrix.det_diagonal, Fin.prod_univ_three]
      have hk : (4 * κ : ℝ) ≠ 0 := mul_ne_zero (by norm_num) (ne_of_gt hκ)
      exact mul_ne_zero (mul_ne_zero hk hk) hk
    exact Matrix.nondegenerate_of_det_ne_zero hdet
  · exact spacetime_metric_congruent_stdLorentz_of_kappa_pos κ hκ
  · exact no_nonzero_invariant_covector_of_kappa_pos κ hκ
  · exact absolute_time_line_not_invariant_of_kappa_pos κ hκ

theorem zero_kappa_has_concrete_invariant_time_line :
    absoluteTimeCovector ∈ timeLineSubmodule ∧
      (∀ i : SpatialIndex,
        ⁅rotationGenerator 0 i, absoluteTimeCovector⁆ = 0 ∧
          ⁅boostGenerator 0 i, absoluteTimeCovector⁆ = 0) := by
  refine ⟨absoluteTimeCovector_mem_timeLineSubmodule, ?_⟩
  intro i
  exact absoluteTimeCovector_invariant_at_kappa_zero i

theorem phase1_selection_summary (κ : ℝ) :
    (κ < 0 →
      preferredBranch κ = Branch.euclidean ∧
        ∀ v : SpacetimeIndex → ℝ,
          v ≠ 0 → dotProduct v (Matrix.mulVec (spacetime_metric κ) v) ≠ 0) ∧
    (κ = 0 →
      preferredBranch κ = Branch.galilean ∧
        ¬ Matrix.Nondegenerate (velocityMetricMatrix 0) ∧
        ¬ Matrix.Nondegenerate (spacetime_metric 0) ∧
        boostKillingBlock 0 = 0 ∧
        absoluteTimeCovector ∈ timeLineSubmodule ∧
        (∀ i : SpatialIndex,
          ⁅rotationGenerator 0 i, absoluteTimeCovector⁆ = 0 ∧
            ⁅boostGenerator 0 i, absoluteTimeCovector⁆ = 0) ∧
        timeLineSubmodule ≠ ⊥ ∧
        timeLineSubmodule ≠ ⊤) ∧
    (0 < κ →
      preferredBranch κ = Branch.lorentz ∧
        Matrix.Nondegenerate (velocityMetricMatrix κ) ∧
        Matrix.transpose (lorentzCongruenceMatrix κ) * spacetime_metric κ *
            lorentzCongruenceMatrix κ = Matrix.diagonal ![1, -1, -1, -1] ∧
        0 < invariantSpeedSquared κ ∧
        (∃ c : ℝ, 0 < c ∧ c^2 = invariantSpeedSquared κ) ∧
        (∀ v : SpacetimeIndex → ℝ, (∀ i : SpatialIndex, ⁅boostGenerator κ i, v⁆ = 0) → v = 0) ∧
        (∃ i : SpatialIndex, ⁅boostGenerator κ i, absoluteTimeCovector⁆ ∉
          (absoluteTimeLine : Set (SpacetimeIndex → ℝ)))) := by
  constructor
  · intro hneg
    exact ⟨negative_kappa_selects_euclidean κ hneg,
      negative_kappa_no_nonzero_null_vectors κ hneg⟩
  constructor
  · intro hzero
    subst hzero
    obtain ⟨htimeMem, htimeInvariant⟩ := zero_kappa_has_concrete_invariant_time_line
    obtain ⟨hneqBot, hneqTop⟩ := reducible_of_kappa_zero
    have hboostDegenerate : ¬ Matrix.Nondegenerate (velocityMetricMatrix 0) := by
      intro hnondeg
      have hone : (![1, 0, 0] : SpatialIndex → ℝ) ≠ 0 := by
        intro hzero
        have hentry := congrArg (fun v => v 0) hzero
        simp at hentry
      rw [velocityMetricMatrix_at_zero] at hnondeg
      obtain ⟨w, hw⟩ := hnondeg.exists_not_ortho_of_ne_zero hone
      have horth : dotProduct (![1, 0, 0] : SpatialIndex → ℝ)
          (Matrix.mulVec (0 : RealSquareMatrix SpatialDim) w) = 0 := by
        simp [Matrix.mulVec, dotProduct]
      exact hw horth
    exact ⟨zero_kappa_selects_galilean, hboostDegenerate,
      spacetime_metric_degenerate_of_kappa_zero, boost_killing_form_vanishes_at_zero,
      htimeMem, htimeInvariant, hneqBot, hneqTop⟩
  · intro hpos
    exact selection_of_positive_kappa κ hpos

theorem full_paper_selection_summary (κ : ℝ) :
    (κ < 0 →
      preferredBranch κ = Branch.euclidean ∧
        ∀ v : SpacetimeIndex → ℝ,
          v ≠ 0 → dotProduct v (Matrix.mulVec (spacetime_metric κ) v) ≠ 0) ∧
    (κ = 0 →
      preferredBranch κ = Branch.galilean ∧
        ¬ Matrix.Nondegenerate (velocityMetricMatrix 0) ∧
        ¬ Matrix.Nondegenerate (spacetime_metric 0) ∧
        boostKillingBlock 0 = 0 ∧
        absoluteTimeCovector ∈ timeLineSubmodule ∧
        (∀ i : SpatialIndex,
          ⁅rotationGenerator 0 i, absoluteTimeCovector⁆ = 0 ∧
            ⁅boostGenerator 0 i, absoluteTimeCovector⁆ = 0) ∧
        timeLineSubmodule ≠ ⊥ ∧
        timeLineSubmodule ≠ ⊤ ∧
        ∀ G : RealSquareMatrix SpacetimeDim,
          isInvariantSymmetricSpacetimeForm 0 G →
            ∃ c : ℝ, G = c • Matrix.diagonal ![1, 0, 0, 0]) ∧
    (0 < κ →
      preferredBranch κ = Branch.lorentz ∧
        Matrix.Nondegenerate (velocityMetricMatrix κ) ∧
        Matrix.transpose (lorentzCongruenceMatrix κ) * spacetime_metric κ *
            lorentzCongruenceMatrix κ = Matrix.diagonal ![1, -1, -1, -1] ∧
        0 < invariantSpeedSquared κ ∧
        (∃ c : ℝ, 0 < c ∧ c^2 = invariantSpeedSquared κ) ∧
        (∀ v : SpacetimeIndex → ℝ, (∀ i : SpatialIndex, ⁅boostGenerator κ i, v⁆ = 0) → v = 0) ∧
        (∃ i : SpatialIndex, ⁅boostGenerator κ i, absoluteTimeCovector⁆ ∉
          (absoluteTimeLine : Set (SpacetimeIndex → ℝ))) ∧
        ∀ G : RealSquareMatrix SpacetimeDim,
          isInvariantSymmetricSpacetimeForm κ G →
            ∃ c : ℝ, G = c • spacetime_metric κ) := by
  constructor
  · intro hneg
    exact (phase1_selection_summary κ).1 hneg
  constructor
  · intro hzero
    obtain ⟨hbranch, hboostDegenerate, hspacetimeDegenerate, hboostZero,
      htimeMem, htimeInvariant, hneqBot, hneqTop⟩ := (phase1_selection_summary κ).2.1 hzero
    subst hzero
    refine ⟨hbranch, hboostDegenerate, hspacetimeDegenerate, hboostZero,
      htimeMem, htimeInvariant, hneqBot, hneqTop, ?_⟩
    intro G hG
    exact galilean_invariant_symmetric_form_eq_dt2_scalar hG
  · intro hpos
    obtain ⟨hbranch, hnondeg, hlorentz, hspeed, hspeedWitness, hcovector, htimeLine⟩ :=
      (phase1_selection_summary κ).2.2 hpos
    refine ⟨hbranch, hnondeg, hlorentz, hspeed, hspeedWitness, hcovector, htimeLine, ?_⟩
    intro G hG
    exact spacetime_invariant_symmetric_form_scalar_of_kappa_pos κ hpos hG

theorem positive_branch_is_phase1_target (κ : ℝ) (hκ : 0 < κ) :
    preferredBranch κ = Branch.lorentz := by
  exact positive_kappa_selects_lorentz κ hκ

end OnePostulate
