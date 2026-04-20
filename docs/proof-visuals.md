# Proof Visuals

This page expands the proof map from the root README. It is meant for readers who want the public story of the repository without dropping directly into Lean source.

## The Matrix-First Route

The formalization is intentionally concrete.

1. Write down explicit spacetime generators for rotations and boosts.
2. Use those matrices to prove the homogeneous bracket table.
3. Turn the bracket table into an adjoint representation.
4. Compute the Killing form from that adjoint action.
5. Read the boost-sector and spacetime consequences from the resulting invariant form.

That choice matches the paper's local narrative: geometry is recovered from the algebra's own invariant, not imposed first.

```mermaid
flowchart LR
    A["Relativity principle<br/>one-parameter kinematic family"] --> B["Bracket structure<br/>adjoint setup"]
    B --> C["Killing form computation"]
    C --> D["Boost-sector and spacetime consequences<br/>geometry is read off here, not assumed first"]
    D --> E["Three kappa branches<br/>Euclidean / Galilean / Lorentzian"]
```

## Module Flow

```mermaid
flowchart LR
    A["SpacetimeMatrices<br/>explicit 4x4 generators"] --> B["KinematicAlgebra<br/>six-dimensional algebra and bracket table"]
    B --> C["KillingForm<br/>adjoint matrices and trace form"]
    C --> D["VelocitySpace<br/>boost-sector metric behavior"]
    C --> E["SpacetimeRepresentation<br/>invariant spacetime forms"]
    D --> F["Selection<br/>phase-1 branch split"]
    E --> F
    F --> G["ClassificationDerivation<br/>full-paper bridge"]
```

## Theorem Spine

```mermaid
flowchart TD
    A["matrix_bracket_JJ / matrix_bracket_JK / matrix_bracket_KK"] --> B["kinematic_bracket_table"]
    B --> C["kinematic_bracket_jacobi"]
    B --> D["killing_form_diag"]
    D --> E["boost_killing_form_eq"]
    E --> F["boost_killing_nondegenerate_iff_kappa_ne_zero"]
    E --> G["killing_restricts_to_metric"]
    G --> H["zero_kappa_velocity_metric_only_conformal"]
    G --> I["invariantSpeedSquared_formula"]
    D --> J["spacetime_metric_eq_diagonal"]
    J --> K["spacetime_metric_invariant"]
    K --> L["reducible_of_kappa_zero"]
    K --> M["spacetime_metric_congruent_stdLorentz_of_kappa_pos"]
    H --> N["phase1_selection_summary"]
    I --> N
    L --> N
    M --> N
    N --> O["classification_derivation_complete / classification_derivation_complete_full"]
```

## The Branch Split

```mermaid
flowchart LR
    K["kappa"] --> N["kappa < 0<br/>negative_kappa_selects_euclidean<br/>negative_kappa_no_nonzero_null_vectors"]
    K --> Z["kappa = 0<br/>zero_kappa_selects_galilean<br/>reducible_of_kappa_zero"]
    K --> P["kappa > 0<br/>positive_kappa_selects_lorentz<br/>positive_kappa_gives_finite_real_invariant_speed"]
```

## Paper / Lean / Notebook Crosswalk

```mermaid
flowchart TB
    subgraph S1["Bracket setup"]
        direction LR
        P1["Paper<br/>The postulate / What the postulate determines"]
        L1["Lean<br/>SpacetimeMatrices + KinematicAlgebra<br/>matrix_bracket_JJ / matrix_bracket_JK / matrix_bracket_KK / kinematic_bracket_table"]
        N1["Notebook<br/>Transformation law, Galilean limit, adopted algebra"]
        P1 --> L1 --> N1
    end
    subgraph S2["Killing form"]
        direction LR
        P2["Paper<br/>Can the rules examine themselves?"]
        L2["Lean<br/>KillingForm + VelocitySpace<br/>killing_form_diag / boost_killing_form_eq / killing_restricts_to_metric"]
        N2["Notebook<br/>Adjoint action and Killing form"]
        P2 --> L2 --> N2
    end
    subgraph S3["Branch classification"]
        direction LR
        P3["Paper<br/>Three verdicts / Structure and scale"]
        L3["Lean<br/>SpacetimeRepresentation + Selection + ClassificationDerivation<br/>phase1_selection_summary / classification_derivation_complete_full"]
        N3["Notebook<br/>Regime table and branch comparison"]
        P3 --> L3 --> N3
    end
    S1 --> S2 --> S3
```

| Paper section | Lean files and theorems | Notebook surface |
| --- | --- | --- |
| `The postulate` / `What the postulate determines` | [`OnePostulate/SpacetimeMatrices.lean`](../OnePostulate/SpacetimeMatrices.lean), [`OnePostulate/KinematicAlgebra.lean`](../OnePostulate/KinematicAlgebra.lean), `matrix_bracket_JJ`, `matrix_bracket_JK`, `matrix_bracket_KK`, `kinematic_bracket_table` | SymPy opening sections on the transformation law, Galilean limit, and adopted algebra |
| `Can the rules examine themselves?` | [`OnePostulate/KillingForm.lean`](../OnePostulate/KillingForm.lean), [`OnePostulate/VelocitySpace.lean`](../OnePostulate/VelocitySpace.lean), `killing_form_diag`, `boost_killing_form_eq`, `killing_restricts_to_metric` | SymPy middle sections on adjoint action and Killing form |
| `Three verdicts` / `Structure and scale` | [`OnePostulate/SpacetimeRepresentation.lean`](../OnePostulate/SpacetimeRepresentation.lean), [`OnePostulate/Selection.lean`](../OnePostulate/Selection.lean), [`OnePostulate/ClassificationDerivation.lean`](../OnePostulate/ClassificationDerivation.lean), `phase1_selection_summary`, `classification_derivation_complete_full` | SymPy regime table and branch comparison |

## Proof Authority

- The paper is the local source for the narrative claim ordering.
- The Lean files are the proof authority for repository claims.
- The notebook surfaces are computational companions:
  they expose symbolic structure, but they do not replace the Lean proof.
