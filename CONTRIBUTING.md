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

## License

This repository now uses a split public license described in [`LICENSE`](LICENSE):

- Code surfaces such as Lean proofs, Wolfram scripts, Python notebooks, and build infrastructure are licensed under [`LICENSES/LICENSE-CODE`](LICENSES/LICENSE-CODE) (Apache 2.0).
- Paper and documentation surfaces such as `paper/`, `docs/`, `README.md`, `blueprint/`, and the SVG assets are licensed under [`LICENSES/LICENSE-DOCS`](LICENSES/LICENSE-DOCS) (CC BY 4.0).

If you contribute across both surfaces, expect the code portion of your change to be distributed under Apache 2.0 and the paper/documentation portion to be distributed under CC BY 4.0.
