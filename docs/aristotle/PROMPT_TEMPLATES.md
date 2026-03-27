# Prompt Templates

Back to [Aristotle docs home](README.md). See also [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md).

## How To Use These Prompts

- Run from the repository root with `--project-dir .` when you want repo context.
- Narrow the scope whenever possible.
- Repeat the proof-surface rule in the prompt if the target touches `OnePostulate.lean`, `OnePostulateFull.lean`, or `OnePostulate/ClassificationDerivation.lean`.

## Fill All Future `sorry`s

```text
Fill the remaining proof holes in this Lean project.
Preserve theorem statements.
Preserve imports.
Do not widen the phase-1 root.
Do not import OnePostulate.ClassificationDerivation into OnePostulate.lean.
```

## Repair One File

```text
Repair proofs in OnePostulate/Selection.lean only.
Preserve theorem statements and imports.
Do not widen the phase-1 root.
```

## Prove One Theorem

```text
Prove the target theorem in OnePostulate/ClassificationDerivation.lean.
Do not change the theorem statement.
Do not add imports to OnePostulate.lean.
Keep deferred/full-paper work separate from the phase-1 root.
```

## Formalize A Paper Section

```text
Formalize the relevant argument from paper/one-postulate.tex into Lean-oriented statements and proof sketches.
Keep the result aligned with this repository's import surface.
Do not widen the phase-1 root.
```

## Generate Auxiliary Lemmas

```text
Generate only auxiliary lemmas needed to finish the target proof.
Keep each lemma small and reviewable.
Do not change theorem statements.
Do not widen imports.
```

## Validate Theorem Statements Against The Paper

```text
Validate theorem statements in this repository against paper/one-postulate.tex.
Report mismatches explicitly.
Do not change theorem statements unless you can justify a false statement with a counterexample or proof of the negation.
```

## Search For Counterexamples

```text
Search for a counterexample or a proof of the negation for the target claim.
If the claim is false, explain why.
Do not widen imports and do not silently repair the theorem statement.
```

## Validate The Current Lean Surface

```text
Validate the Lean project in this repository.
Keep OnePostulate.lean free of OnePostulate.ClassificationDerivation.
Check OnePostulate/ClassificationDerivation.lean and OnePostulateFull.lean separately for deferred/full-paper work.
Do not change theorem statements unless you find a genuine false statement and explain it.
```

## Use The `PROVIDED SOLUTION` Pattern

Aristotle can use theorem-header comments as guidance. It does not reliably use
comments inside proof blocks.

Use this pattern above the theorem, not inside the proof:

```lean
/--
PROVIDED SOLUTION:
- First reduce the target to the phase-1 root.
- Then use the full-paper bridge only through OnePostulateFull.lean.
- Do not import OnePostulate.ClassificationDerivation into OnePostulate.lean.
- Preserve the theorem statement.
-/
theorem target_theorem : ... := by
  ...
```

Do not rely on comments nested deep inside a proof block to steer Aristotle.

## Prompting Tips For This Repo

- Mention the exact target file.
- State whether the work is phase 1 or deferred/full-paper.
- Say whether theorem statements are frozen.
- Say whether imports are frozen.
- If the repo build is already green, say so and ask for minimal edits.

## See Also

- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)
- [Counterexamples and debugging](COUNTEREXAMPLES_AND_DEBUGGING.md)

