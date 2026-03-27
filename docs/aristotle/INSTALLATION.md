# Installation

Back to [Aristotle docs home](README.md). See also [CLI workflows](CLI_WORKFLOWS.md).

## Requirements

- Python 3.10 or newer
- access to an Aristotle API key
- a working Lean toolchain for this repository

## Install With `uv`

Recommended:

```bash
uv tool install aristotlelib
uv tool upgrade aristotlelib
uvx --from aristotlelib@latest aristotle --help
```

This keeps the CLI isolated from your repo virtual environments.

## Install With `pip`

Alternative:

```bash
python -m pip install aristotlelib
python -m pip install --upgrade aristotlelib
python -m aristotle --help
```

If your installation exposes the CLI directly, this also works:

```bash
aristotle --help
```

## API Key Setup

Use placeholders only in local notes and scripts. Never commit a live key.

Environment-variable setup:

```bash
export ARISTOTLE_API_KEY="<YOUR_ARISTOTLE_API_KEY>"
```

One-off CLI usage:

```bash
aristotle submit "Prove that the square root of 2 is irrational" --api-key "<YOUR_ARISTOTLE_API_KEY>" --wait
```

If you script against the Python API, read the key from the environment rather
than hard-coding it into the script.

## Verify Installation

Run:

```bash
aristotle --help
aristotle list
```

From this repository root, also confirm your Lean setup before relying on
Aristotle output:

```bash
lake exe cache get
lake build
```

## Secret Handling Rules

- Never commit a real Aristotle key to the repo.
- Never put a live key into `README.md`, `documentation.md`, or anything under `docs/`.
- Never paste a live key into command examples, shell history snippets, or checked-in notebooks.
- If you need a shell example, use `<YOUR_ARISTOTLE_API_KEY>` only.
- If a branch contains generated files with a live key, remove the key before commit and rotate it outside the repo.

## Repo-Specific Notes

- This repo already has a strict proof-surface boundary: `OnePostulate.lean` must stay free of `OnePostulate.ClassificationDerivation`.
- Install Aristotle for validation and repair workflows, not for changing the repo’s proof-surface policy.
- Use `OnePostulateFull.lean` and `OnePostulate/ClassificationDerivation.lean` separately when you want Aristotle to reason about deferred or full-paper material.

## See Also

- [Aristotle docs home](README.md)
- [Lean and Mathlib compatibility](LEAN_COMPATIBILITY.md)

