# Lean and Mathlib Compatibility

Back to [Aristotle docs home](README.md). See also [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md).

## Aristotle Support Baseline

Aristotle’s documented Lean environment is:

- Lean toolchain: `leanprover/lean4:v4.28.0`
- Mathlib commit: `8f9d9cff6bd728b17a24e163c9402775d9e6a365`

Best results come from matching both the Lean toolchain and Mathlib pin as
closely as possible.

## Repo Values Verified From Files

This repository currently reports the following values:

### `lean-toolchain`

```text
leanprover/lean4:v4.28.0
```

### `lakefile.toml`

Mathlib input revision:

```text
v4.28.0
```

### `lake-manifest.json`

Mathlib resolved commit:

```text
8f9d9cff6bd728b17a24e163c9402775d9e6a365
```

## Compatibility Verdict

Verified result from the repo files above:

- the Lean toolchain matches Aristotle’s documented toolchain exactly
- the Mathlib input revision matches `v4.28.0`
- the resolved Mathlib commit matches Aristotle’s documented commit exactly

For this repository, Aristotle and the local project are an exact Lean and
Mathlib match.

## What That Means For Validation

Because the versions match exactly:

- Lean elaboration behavior should line up closely between local checks and Aristotle jobs
- theorem validation has the highest chance of reflecting the repo’s real build state
- imported APIs and parser behavior should match the environment Aristotle expects

This does not remove the need for local validation. You should still rerun local
checks after reviewing Aristotle output.

## If The Repo Ever Drifts

If `lean-toolchain`, `lakefile.toml`, or `lake-manifest.json` diverge from
Aristotle’s support baseline, document the mismatch and assume lower confidence
in these workflows:

- proving statements that depend on recently changed APIs
- validating theorem statements against paper text
- comparing local build failures against Aristotle-generated patches
- using generated code without a full local rebuild

Typical mismatch symptoms:

- parser failures
- missing constants or renamed APIs
- elaboration differences on tactics or imported lemmas
- proofs that work for Aristotle but fail locally

## Repo Preflight

Before relying on Aristotle in this repo, run:

```bash
lake exe cache get
lake build
```

For deferred and full-paper material, also run:

```bash
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
```

## Proof-Surface Implication

Compatibility is necessary, but it is not the only guard in this repo. Even with
an exact version match:

- do not import `OnePostulate.ClassificationDerivation` into `OnePostulate.lean`
- use `OnePostulateFull.lean` and `OnePostulate/ClassificationDerivation.lean` for full-paper or deferred checks
- reject Aristotle output that widens the phase-1 root by accident

## See Also

- [Aristotle docs home](README.md)
- [Lean validation workflow](LEAN_VALIDATION_WORKFLOW.md)

