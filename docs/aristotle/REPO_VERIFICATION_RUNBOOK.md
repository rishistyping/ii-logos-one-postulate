# Repository Verification Runbook

Back to [Aristotle docs home](README.md). See also [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md).

## 1. Local preflight results

Compatibility:

- `lean-toolchain` = `leanprover/lean4:v4.28.0`
- `lakefile.toml` Mathlib rev = `v4.28.0`
- `lake-manifest.json` Mathlib commit = `8f9d9cff6bd728b17a24e163c9402775d9e6a365`
- verdict = exact Aristotle-compatible Lean/Mathlib match

Local checks:

- `lake exe cache get` passed
- `lake build` passed
- `lake build OnePostulate` passed
- `lake env lean OnePostulate/ClassificationDerivation.lean` passed
- `lake env lean OnePostulateFull.lean` passed

Surface checks:

- no `sorry|admit` found in `OnePostulateFull.lean`, `OnePostulate.lean`, `OnePostulate/*.lean`
- no `OnePostulate.ClassificationDerivation` import found in `OnePostulate.lean`

Warnings:

- existing non-blocking warnings only in `OnePostulate/KinematicAlgebra.lean` and `OnePostulate/SpacetimeRepresentation.lean`

## 2. Exact main-surface Aristotle prompt

```text
Validate the repository's main Lean surface rooted at OnePostulate.lean.

Primary source of truth: paper/one-postulate.tex
Cross-check only: paper/one-postulate.pdf

Treat OnePostulate.lean as the repository's main imported root. Validate the current main-surface files it imports as needed, especially:
- OnePostulate/KinematicAlgebra.lean
- OnePostulate/KillingForm.lean
- OnePostulate/VelocitySpace.lean
- OnePostulate/SpacetimeRepresentation.lean
- OnePostulate/Selection.lean

Verify that the Lean development matches the paper on these points:
- bracket table [J_i, J_j] = epsilon_ijk J_k, [J_i, K_j] = epsilon_ijk K_k, [K_i, K_j] = -kappa epsilon_ijk J_k
- Killing form diag(-4 I3, 4 kappa I3)
- boost-sector metric fixed by the Killing form when kappa != 0
- at kappa = 0, only a conformal class is fixed on velocity space
- spacetime metric proportional to diag(1, -kappa, -kappa, -kappa)
- kappa < 0 Euclidean / no-null branch
- kappa = 0 degenerate boost Killing form + invariant dt + reducible spacetime representation
- kappa > 0 Lorentzian metric + finite real invariant speed

Constraints:
- do not widen the repository's current import surface
- do not import OnePostulate.ClassificationDerivation into OnePostulate.lean
- treat OnePostulate/ClassificationDerivation.lean as outside the main imported root and do not use it to justify phase-1 claims
- do not change theorem statements unless you find a genuine paper-to-Lean mismatch or a false statement and explain it
- prefer verification and minimal repair over broad rewriting
- preserve the current matrix-first proof style

Return a structured report with these exact sections:
- Summary
- Build status
- Placeholder status
- Import-surface check
- Paper-to-Lean fidelity
- Issues found
- Minimal fixes applied
- Remaining warnings
- Final recommendation
```

## 3. Exact full-paper Aristotle prompt

```text
Validate the supplemental/full-paper Lean surface against the paper.

Primary source of truth: paper/one-postulate.tex
Cross-check only: paper/one-postulate.pdf

Treat these as the target Lean surfaces for this job:
- OnePostulateFull.lean
- OnePostulate/ClassificationDerivation.lean

Goals:
- verify that the supplemental/full-paper surface agrees with the paper's branch split and branch conclusions
- verify that OnePostulateFull.lean extends the main surface without changing the repository's main import boundary
- verify that OnePostulate/ClassificationDerivation.lean remains supplemental and unimported by OnePostulate.lean

Check the bridge from the explicit matrix-first phase-1 results to the full-paper packaging, including:
- the Euclidean branch at kappa < 0
- the Galilean branch at kappa = 0, including degenerate boost Killing form, conformal-only velocity-space structure, reducible spacetime representation, and invariant dt / dt^2 structure
- the Lorentz branch at kappa > 0, including nondegenerate boost metric, Lorentzian spacetime metric, and finite real invariant speed
- the separation between the main imported root OnePostulate.lean and the supplemental full-paper surface

Constraints:
- preserve the repository's current main import boundary in OnePostulate.lean
- do not import OnePostulate.ClassificationDerivation into OnePostulate.lean
- do not widen the proof surface
- do not change theorem statements unless you find a genuine paper-to-Lean mismatch or a false statement and explain it
- prefer verification and minimal repair over broad rewriting
- preserve the current matrix-first proof style

Return a structured report with these exact sections:
- Summary
- Build status
- Placeholder status
- Import-surface check
- Paper-to-Lean fidelity
- Issues found
- Minimal fixes applied
- Remaining warnings
- Final recommendation
```

## 4. Exact CLI command for main-surface validation

Environment-auth version:

```bash
MAIN_SURFACE_PROMPT=$(cat <<'EOF'
Validate the repository's main Lean surface rooted at OnePostulate.lean.

Primary source of truth: paper/one-postulate.tex
Cross-check only: paper/one-postulate.pdf

Treat OnePostulate.lean as the repository's main imported root. Validate the current main-surface files it imports as needed, especially:
- OnePostulate/KinematicAlgebra.lean
- OnePostulate/KillingForm.lean
- OnePostulate/VelocitySpace.lean
- OnePostulate/SpacetimeRepresentation.lean
- OnePostulate/Selection.lean

Verify that the Lean development matches the paper on these points:
- bracket table [J_i, J_j] = epsilon_ijk J_k, [J_i, K_j] = epsilon_ijk K_k, [K_i, K_j] = -kappa epsilon_ijk J_k
- Killing form diag(-4 I3, 4 kappa I3)
- boost-sector metric fixed by the Killing form when kappa != 0
- at kappa = 0, only a conformal class is fixed on velocity space
- spacetime metric proportional to diag(1, -kappa, -kappa, -kappa)
- kappa < 0 Euclidean / no-null branch
- kappa = 0 degenerate boost Killing form + invariant dt + reducible spacetime representation
- kappa > 0 Lorentzian metric + finite real invariant speed

Constraints:
- do not widen the repository's current import surface
- do not import OnePostulate.ClassificationDerivation into OnePostulate.lean
- treat OnePostulate/ClassificationDerivation.lean as outside the main imported root and do not use it to justify phase-1 claims
- do not change theorem statements unless you find a genuine paper-to-Lean mismatch or a false statement and explain it
- prefer verification and minimal repair over broad rewriting
- preserve the current matrix-first proof style

Return a structured report with these exact sections:
- Summary
- Build status
- Placeholder status
- Import-surface check
- Paper-to-Lean fidelity
- Issues found
- Minimal fixes applied
- Remaining warnings
- Final recommendation
EOF
)
aristotle submit "$MAIN_SURFACE_PROMPT" --project-dir . --wait
```

Explicit `--api-key` version:

```bash
MAIN_SURFACE_PROMPT=$(cat <<'EOF'
Validate the repository's main Lean surface rooted at OnePostulate.lean.

Primary source of truth: paper/one-postulate.tex
Cross-check only: paper/one-postulate.pdf

Treat OnePostulate.lean as the repository's main imported root. Validate the current main-surface files it imports as needed, especially:
- OnePostulate/KinematicAlgebra.lean
- OnePostulate/KillingForm.lean
- OnePostulate/VelocitySpace.lean
- OnePostulate/SpacetimeRepresentation.lean
- OnePostulate/Selection.lean

Verify that the Lean development matches the paper on these points:
- bracket table [J_i, J_j] = epsilon_ijk J_k, [J_i, K_j] = epsilon_ijk K_k, [K_i, K_j] = -kappa epsilon_ijk J_k
- Killing form diag(-4 I3, 4 kappa I3)
- boost-sector metric fixed by the Killing form when kappa != 0
- at kappa = 0, only a conformal class is fixed on velocity space
- spacetime metric proportional to diag(1, -kappa, -kappa, -kappa)
- kappa < 0 Euclidean / no-null branch
- kappa = 0 degenerate boost Killing form + invariant dt + reducible spacetime representation
- kappa > 0 Lorentzian metric + finite real invariant speed

Constraints:
- do not widen the repository's current import surface
- do not import OnePostulate.ClassificationDerivation into OnePostulate.lean
- treat OnePostulate/ClassificationDerivation.lean as outside the main imported root and do not use it to justify phase-1 claims
- do not change theorem statements unless you find a genuine paper-to-Lean mismatch or a false statement and explain it
- prefer verification and minimal repair over broad rewriting
- preserve the current matrix-first proof style

Return a structured report with these exact sections:
- Summary
- Build status
- Placeholder status
- Import-surface check
- Paper-to-Lean fidelity
- Issues found
- Minimal fixes applied
- Remaining warnings
- Final recommendation
EOF
)
aristotle submit "$MAIN_SURFACE_PROMPT" --project-dir . --wait --api-key "<YOUR_ARISTOTLE_API_KEY>"
```

## 5. Exact CLI command for full-paper validation

Environment-auth version:

```bash
FULL_PAPER_PROMPT=$(cat <<'EOF'
Validate the supplemental/full-paper Lean surface against the paper.

Primary source of truth: paper/one-postulate.tex
Cross-check only: paper/one-postulate.pdf

Treat these as the target Lean surfaces for this job:
- OnePostulateFull.lean
- OnePostulate/ClassificationDerivation.lean

Goals:
- verify that the supplemental/full-paper surface agrees with the paper's branch split and branch conclusions
- verify that OnePostulateFull.lean extends the main surface without changing the repository's main import boundary
- verify that OnePostulate/ClassificationDerivation.lean remains supplemental and unimported by OnePostulate.lean

Check the bridge from the explicit matrix-first phase-1 results to the full-paper packaging, including:
- the Euclidean branch at kappa < 0
- the Galilean branch at kappa = 0, including degenerate boost Killing form, conformal-only velocity-space structure, reducible spacetime representation, and invariant dt / dt^2 structure
- the Lorentz branch at kappa > 0, including nondegenerate boost metric, Lorentzian spacetime metric, and finite real invariant speed
- the separation between the main imported root OnePostulate.lean and the supplemental full-paper surface

Constraints:
- preserve the repository's current main import boundary in OnePostulate.lean
- do not import OnePostulate.ClassificationDerivation into OnePostulate.lean
- do not widen the proof surface
- do not change theorem statements unless you find a genuine paper-to-Lean mismatch or a false statement and explain it
- prefer verification and minimal repair over broad rewriting
- preserve the current matrix-first proof style

Return a structured report with these exact sections:
- Summary
- Build status
- Placeholder status
- Import-surface check
- Paper-to-Lean fidelity
- Issues found
- Minimal fixes applied
- Remaining warnings
- Final recommendation
EOF
)
aristotle submit "$FULL_PAPER_PROMPT" --project-dir . --wait
```

Explicit `--api-key` version:

```bash
FULL_PAPER_PROMPT=$(cat <<'EOF'
Validate the supplemental/full-paper Lean surface against the paper.

Primary source of truth: paper/one-postulate.tex
Cross-check only: paper/one-postulate.pdf

Treat these as the target Lean surfaces for this job:
- OnePostulateFull.lean
- OnePostulate/ClassificationDerivation.lean

Goals:
- verify that the supplemental/full-paper surface agrees with the paper's branch split and branch conclusions
- verify that OnePostulateFull.lean extends the main surface without changing the repository's main import boundary
- verify that OnePostulate/ClassificationDerivation.lean remains supplemental and unimported by OnePostulate.lean

Check the bridge from the explicit matrix-first phase-1 results to the full-paper packaging, including:
- the Euclidean branch at kappa < 0
- the Galilean branch at kappa = 0, including degenerate boost Killing form, conformal-only velocity-space structure, reducible spacetime representation, and invariant dt / dt^2 structure
- the Lorentz branch at kappa > 0, including nondegenerate boost metric, Lorentzian spacetime metric, and finite real invariant speed
- the separation between the main imported root OnePostulate.lean and the supplemental full-paper surface

Constraints:
- preserve the repository's current main import boundary in OnePostulate.lean
- do not import OnePostulate.ClassificationDerivation into OnePostulate.lean
- do not widen the proof surface
- do not change theorem statements unless you find a genuine paper-to-Lean mismatch or a false statement and explain it
- prefer verification and minimal repair over broad rewriting
- preserve the current matrix-first proof style

Return a structured report with these exact sections:
- Summary
- Build status
- Placeholder status
- Import-surface check
- Paper-to-Lean fidelity
- Issues found
- Minimal fixes applied
- Remaining warnings
- Final recommendation
EOF
)
aristotle submit "$FULL_PAPER_PROMPT" --project-dir . --wait --api-key "<YOUR_ARISTOTLE_API_KEY>"
```

## 6. Safe review checklist

Use this exact checklist after either Aristotle run:

1. Record the project ID and inspect the result:
- `aristotle list`
- `aristotle result <PROJECT_ID>`

2. If a bundle is available, review it outside tracked source:
- `mkdir -p results review/<PROJECT_ID>`
- download the bundle into `results/<PROJECT_ID>.tar.gz`
- `tar -xzf results/<PROJECT_ID>.tar.gz -C review/<PROJECT_ID>`
- `diff -ru review/<PROJECT_ID> .`

3. Re-run local Lean validation:
- `lake build`
- `lake build OnePostulate`
- `lake env lean OnePostulate/ClassificationDerivation.lean`
- `lake env lean OnePostulateFull.lean`

4. Re-run the surface guards:
- `grep -nE 'sorry|admit' OnePostulateFull.lean OnePostulate.lean OnePostulate/*.lean || true`
- `grep -nE '^[[:space:]]*import[[:space:]]+OnePostulate\.ClassificationDerivation([[:space:]]|$)' OnePostulate.lean || true`

5. Reject any Aristotle output that:
- widens the proof surface
- imports `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`
- uses the supplemental/full-paper surface to justify phase-1 claims
- changes theorem statements unexpectedly
- performs broad rewriting when a narrow verification or minimal repair would do

6. Treat negation proofs or counterexample comments as review signals, not merge-ready output.

7. Accept only if:
- local build stays green
- no `sorry|admit`
- proof-surface guards stay intact
- theorem statements remain stable unless a real paper mismatch was explicitly demonstrated
- no secret material appears anywhere

## 7. Any blockers

- no current local tool-install blocker

The remaining operational requirement is local credential setup outside the repo. Do not store or print a live API key in any tracked file. Use `<YOUR_ARISTOTLE_API_KEY>` only in written artifacts.

## See also

- [Aristotle docs home](README.md)
- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)
- [Counterexamples and debugging](COUNTEREXAMPLES_AND_DEBUGGING.md)
- [CI and review](CI_AND_REVIEW.md)
