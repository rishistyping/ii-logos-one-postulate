# Counterexamples and Debugging

Back to [Aristotle docs home](README.md). See also [Prompt templates](PROMPT_TEMPLATES.md).

## What Aristotle May Return When A Claim Is Wrong

Aristotle can do more than fail to prove a statement. It may:

- produce a proof of the negation
- attach comments explaining why the target is false
- surface a counterexample-oriented explanation

Treat that output as review material. Do not merge it automatically.

## Use Counterexamples Safely In This Repo

Before changing any theorem statement:

- compare the result against `paper/one-postulate.tex`
- check whether the issue is local to `OnePostulate/ClassificationDerivation.lean` or affects a phase-1 theorem
- confirm that Aristotle did not widen imports to make the statement look false or true under the wrong surface

## Distinguish The Main Failure Modes

### False statement

Signals:

- Aristotle provides a proof of the negation
- Aristotle explains an explicit contradiction
- local attempts fail for conceptual reasons, not syntax reasons

Action:

- review the target statement against the paper
- inspect hypotheses
- do not patch the theorem casually

### Missing lemma

Signals:

- the statement looks plausible
- Aristotle proposes useful sublemmas
- proof search stalls after partial progress

Action:

- ask for smaller auxiliary lemmas
- keep theorem statements frozen

### Toolchain mismatch

Signals:

- Aristotle output uses missing APIs or behaves differently from local Lean
- parser or elaboration failures appear without mathematical changes

Action:

- re-check `lean-toolchain`, `lakefile.toml`, and `lake-manifest.json`
- rerun `lake build`

### Parsing issue

Signals:

- malformed generated syntax
- broken imports
- result bundle looks truncated or partially corrected

Action:

- narrow the prompt
- target one file or one theorem
- restate the proof-surface constraints more explicitly

### Budget exhaustion

Signals:

- project status is `OUT_OF_BUDGET`
- proof is partial or obviously incomplete

Action:

- inspect the old run with `aristotle result <PROJECT_ID>`
- rerun with a narrower scope
- split validation from repair

## Out-Of-Budget Recovery

Practical recovery loop:

```bash
aristotle list
aristotle result <PROJECT_ID>
aristotle submit "Continue working on OnePostulate/ClassificationDerivation.lean only. Preserve theorem statements and imports. Do not widen the phase-1 root." --project-dir . --wait
```

The point is to resume operationally with a tighter target, not to rerun the
entire repository every time.

## Negation Proofs In Comments

If Aristotle inserts comments that amount to a negation proof:

- do not strip them out until you understand the claim
- compare the negated statement against the paper
- decide whether the original theorem is false, underspecified, or just missing a lemma

## `aesop` And Similar Warning Noise

Sometimes Aristotle finds a proof that works but leaves warning-heavy tactic
code. In that situation:

- first verify the proof is mathematically correct
- then request cleanup in a narrow follow-up run
- keep the scope limited to warning cleanup, not theorem restatement

## Proof-Surface Guard

Repeat this during debugging:

- do not import `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`
- use `OnePostulateFull.lean` and `OnePostulate/ClassificationDerivation.lean` for deferred/full-paper work
- reject output that widens the phase-1 root while “fixing” a proof

## See Also

- [Prompt templates](PROMPT_TEMPLATES.md)
- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)

