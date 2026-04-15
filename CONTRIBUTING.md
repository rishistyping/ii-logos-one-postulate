# Contributing

This repository is the formal verification companion to the paper *One Postulate*. The current priority is release readiness: reproducible proof checks, clear public documentation, stable notebook assets, and accurate links.

## What to contribute

Good first contributions are narrow and easy to review:

- Fix broken links, typos, or unclear README/docs wording.
- Improve reproducibility notes for Lean, Wolfram, SymPy, or Colab.
- Report notebook rendering problems with the viewer, browser, and command used.
- Improve generated preview assets without changing the proof boundary.

Scientific claim changes, theorem-surface changes, or paper-interpretation changes need a higher bar. Open a discussion issue first with the exact claim, the affected paper section, and the Lean or notebook surface that would need to change.

## Proof Boundary

Lean is the proof authority for this repository. Wolfram and SymPy notebooks are explanatory companions and symbolic checks, not substitutes for the Lean proof surface.

Before opening a pull request that touches proof or build files, run:

```bash
lake build
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
rg -n 'sorry|admit' OnePostulateFull.lean OnePostulate.lean OnePostulate/*.lean
```

If your change touches notebook assets and you have Wolfram installed, also run:

```bash
wolframscript -file wolfram/build_one_postulate_notebook.wl
```

Do not run `wolframscript -file wolfram/cloud_export_notebook.wl` as part of ordinary contribution work. That command publishes to Wolfram Cloud and requires maintainer credentials.

## License Status

No root license has been selected yet. Until a `LICENSE` file is added, do not assume reuse terms for this repository beyond normal GitHub viewing. If you contribute before the license is chosen, keep changes small and be prepared for maintainers to ask for explicit confirmation that the contribution can be included under the eventual project license.
