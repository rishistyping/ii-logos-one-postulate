# Completed TODO Extraction Report

This report extracts deduplicated completed TODOs from the current Codex thread
and the visible branch history of this repository.

## Source Inventory

- Chat scope: current Codex thread only.
- External chat exports: none were provided at extraction time.
- Branch heads scanned after collapsing aliases by commit:
  - `8f55478`: `main`, `origin/main`, `origin/HEAD`, `rishistyping/muscat`
  - `5c83dca`: `origin/formal-fix-one`
  - `176dd3e`: `origin/formal-fix-two`
  - `46309e7`: `origin/aristotle-one-postulate`
  - `04b2de7`: `origin/sympy-one-postulate`
  - `91880ef`: `mathematica-sympy-one-postulate`, `origin/mathematica-sympy-one-postulate`
- Main ledger rule: include only items with both chat-side evidence and
  tracked repo evidence.
- Appendix rule: completed work without current-thread chat provenance stays in
  appendix, even when the repo evidence is strong.
- Self-reference rule: the current request to create this report is excluded
  from the ledger to avoid a recursive row about this file itself.

## Executive Summary

- Completed TODOs with both chat and repo evidence: 6
- Present on the current branch: 5
- Present across multiple branches: 1
- Present only on another branch: 0
- Ambiguous items: 0

## Completed TODO Ledger

| Completed TODO | Chat Evidence | Repo Evidence | Branches | Availability | Confidence |
| --- | --- | --- | --- | --- | --- |
| Turn the root README into a public landing page that connects the paper, Lean, and notebook story. | Current thread: the user asked to redesign `README.md`, add a stronger overview, a crosswalk, reading paths, and a coherent public-facing narrative. | `3d819f2` began the narrative README rewrite on the shared docs branch line; `fae4848` produced the current landing-page form in `README.md`. | `origin/sympy-one-postulate`, `origin/aristotle-one-postulate`, `mathematica-sympy-one-postulate`, `origin/mathematica-sympy-one-postulate` | multiple branches | High |
| Add proof-oriented visuals and a readable proof-map layer. | Current thread: the user asked for module flow, theorem spine, branch split, Killing-form explainer, and paper/Lean/notebook visual crosswalks. | `fae4848`; `docs/proof-visuals.md`; `docs/assets/killing-form-explainer.svg`; `docs/assets/paper-lean-notebook-crosswalk.svg`; `docs/assets/notebook_preview_*.svg` | `mathematica-sympy-one-postulate`, `origin/mathematica-sympy-one-postulate` | current branch | High |
| Improve the SymPy notebook for general readers and make the Lean proof boundary explicit. | Current thread: the user asked to improve symbolic notebook surfaces while keeping Lean as the proof authority. | `04b2de7`, `9b8d8b8`, `fae4848`; `one_postulate_sympy_colab.ipynb` | `mathematica-sympy-one-postulate`, `origin/mathematica-sympy-one-postulate`, `origin/sympy-one-postulate`, `origin/aristotle-one-postulate` | multiple branches | High |
| Add a Wolfram-facing companion notebook, source build path, and notebook guide. | Current thread: the user asked for a Wolfram companion with a `.wl` source, a public-facing notebook, and preview assets. | `fae4848`; `wolfram/build_one_postulate_notebook.wl`; `notebooks/one_postulate_explainer.nb`; `docs/notebooks.md`; `docs/assets/notebook_preview_*.svg` | `mathematica-sympy-one-postulate`, `origin/mathematica-sympy-one-postulate` | current branch | High |
| Add a README validation story for Aristotle and OpenGauss/Gauss, with a summary of formalization and verification. | Current thread: the user asked to add the validation story for Aristotle by Harmonic and OpenGauss by Math, Inc., and to summarize the formalizations and verifications. | The current branch tip of `README.md` now includes `Formalization and Validation Story`, backed by in-tree Aristotle summaries under `docs/aristotle/runs/...` and project-scoped Gauss configuration in `.gauss/project.yaml`. | `mathematica-sympy-one-postulate`, `origin/mathematica-sympy-one-postulate` | current branch | High |
| Fix Mermaid labels so GitHub renders the proof diagrams. | Current thread: the user reported GitHub Mermaid lexical errors and asked for a fix. | `91880ef`; `README.md`; `docs/proof-visuals.md` | `mathematica-sympy-one-postulate`, `origin/mathematica-sympy-one-postulate` | current branch | High |

## Grouped Narrative

### Public narrative surface

The biggest completed request in the current thread was the public-facing
rewrite of the repository landing page. An earlier README rewrite (`3d819f2`)
already existed on the shared docs branch line, and `fae4848` then turned that
direction into the current branch's compact landing page with visual proof
maps, a clearer paper-to-Lean-to-notebook story, and a public validation
narrative.

### Notebook surface

The symbolic companion work split into two layers. The SymPy notebook gained
paper-aligned narrative framing and a clearer proof-authority boundary, while
the current branch added a Wolfram-facing companion, a notebook guide, and
preview assets. The SymPy portion is shared across multiple branches; the
Wolfram companion is current-branch-only.

### Validation surface

The current branch now exposes the Aristotle and OpenGauss/Gauss story in the
README, but the tracked evidence is asymmetric. Aristotle validation summaries
and reports are archived in-tree; OpenGauss is configured in-tree through
`.gauss/project.yaml`, but this checkout does not include a committed
OpenGauss run archive.

### Branch spread

Two completed TODOs in the main ledger are clearly shared across multiple
branches: the README narrative rewrite and the SymPy notebook narrative
refresh. The other completed TODOs with current-thread provenance are
current-branch work.

## Appendix: Ambiguous

- None.
- The current report intentionally excludes its own creation request to avoid a
  self-referential ledger row.

## Appendix: No Chat Evidence In This Thread

These items are clearly completed in tracked repo content, but they do not have
strong originating TODO evidence in the current thread.

| Completed Work | Repo Evidence | Branches | Why It Stays Out Of The Main Ledger |
| --- | --- | --- | --- |
| Repair the phase-1 Lean surface. | `5c83dca`; updates to `OnePostulate/*.lean` and `blueprint/src/content.tex` | `origin/formal-fix-one` and all later descendant branches except `main` | No explicit originating TODO appears in the current thread. |
| Complete the phase-1 formal fixes and close out branch guards. | `b67c260`, `7c22460`; Lean updates, CI updates, and `documentation.md` guard text | `origin/formal-fix-two`, `origin/sympy-one-postulate`, `origin/aristotle-one-postulate`, current branch | Strong repo evidence, but no current-thread TODO source. |
| Add the full-paper `OnePostulateFull` surface and the deferred classification bridge. | `176dd3e`; `OnePostulateFull.lean`; updates to `ClassificationDerivation`, `Selection`, and `SpacetimeRepresentation` | `origin/formal-fix-two`, `origin/sympy-one-postulate`, `origin/aristotle-one-postulate`, current branch | Present in repo history, but not requested in the current thread. |
| Add Aristotle repository documentation and archive validation runs. | `7e604b9`, `33b22f1`, `ca63e19`, `11d7901`; `docs/aristotle/*` and archived reports | `origin/sympy-one-postulate`, `origin/aristotle-one-postulate`, current branch | The current thread later asked for a README validation story, not the original Aristotle doc/archive work itself. |
| Archive Aristotle validation bundles as tarballs. | `46309e7`; `b96cbb4a-93c2-43c6-b494-98d9cc0b2f6a-aristotle.tar.gz`; `eaa48588-a529-405f-a871-13665c6b85c5-aristotle.tar.gz` | `origin/aristotle-one-postulate` only | Branch-local completed work with no current-thread chat provenance. |

## Appendix: Requested But Not Completed

| Requested Item | Chat Evidence | Current Status |
| --- | --- | --- |
| Complete the full local Lean validation pass for the public-docs refresh. | Current thread: the long public-refresh request required `lake build`, `lake env lean OnePostulate/ClassificationDerivation.lean`, and `lake env lean OnePostulateFull.lean`. | Not completed. The user later explicitly narrowed the task to the public-facing docs/notebook refresh and asked to stop the builds. |
| Run a live Wolfram notebook regeneration under a working local engine. | Current thread: the notebook refresh request asked for Wolfram build execution if local tooling was available. | Partially satisfied. Source files and committed notebook assets were added, but a successful local Wolfram regeneration was not archived in this checkout. |
