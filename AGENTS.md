## Wolfram Notebook Workflow

Always prefer the Wolfram MCP server when the task involves symbolic algebra,
exact simplification, matrix computations, plotting, exported figure
generation, interactive visualization generation, parameter sweeps, or
notebook construction support.

Use Wolfram MCP for computation and visualization work, not as the source of
truth for theorem names, Lean module names, proof-structure claims, or paper
claims. Those must come from local repository inspection only.

## Canonical Artifacts

- Canonical editable source: `wolfram/build_one_postulate_notebook.wl`
- Frozen narrative and visual spec: `wolfram/notebook_plan.md`
- Generated notebook artifact: `wolfram/notebooks/one_postulate_explainer.nb`
- Canonical public-facing assets: `wolfram/assets/*.svg`
- Public entry surfaces: `README.md`, `docs/notebooks.md`

Do not treat the `.nb` as the primary hand-edited source unless there is a
concrete reason the generator cannot express cleanly.

## Source and Proof Rules

- Use only the local paper and Lean files in this repo as the mathematical
  source of truth.
- Keep Lean as the proof authority. Notebook calculations are explanatory
  computational companions, not formal proofs.
- Separate "computed or visualized here" claims from "formally proved in Lean"
  claims and from interpretive narrative drawn from the paper.
- Do not widen the proof surface.
- Preserve the guarded import boundary:
  - `OnePostulate.lean` is the guarded phase-1 root.
  - `OnePostulateFull.lean` is the full-paper root.
  - `OnePostulate/ClassificationDerivation.lean` is the deferred/full-paper
    bridge.

## Wolfram-Specific Rules

- Keep Wolfram-specific scripts, notebooks, exported assets, and related build
  artifacts under `wolfram/`.
- Prefer source-driven notebook generation from `.wl` files over manual editing
  of large raw notebook expressions.
- Generate runnable Wolfram Language cells, not pseudocode.
- Use Wolfram for exact computations rather than prose-only symbolic
  derivations when exact computation is relevant.
- Keep exported visuals polished, publication-quality, and GitHub-friendly.
- Increase interactivity only when it improves understanding through structural
  contrast, regime change, or conceptual consequence.
- Keep notebook outputs easy to host, share, and present.

## Public-Facing Narrative Rules

- Make public-facing notebook, README, and docs work narrative-first and
  visualization-first.
- Keep the public surfaces suitable for mathematically curious non-Lean readers.
- Align the notebook, README, and docs around the same conceptual sequence.
- Prefer one strong hero visual and a small number of supporting visuals over a
  large number of weaker diagrams.

## Validation Rules

- Do not ask Codex to run extra Lean-side safety-check workflows solely for
  notebook, README, or visualization tasks unless those checks are directly
  required by files Codex actually changed.
