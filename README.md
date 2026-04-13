# One Postulate

Here is the claim in plain language: Einstein used one postulate too many. The relativity principle alone yields a one-parameter family of kinematic universes indexed by `kappa`; the algebra's own built-in measuring tool, the Killing form, rules out the Euclidean and Galilean branches as fundamental; and experiment calibrates the invariant speed instead of positing it. This repository is the formal verification companion to the paper [*One Postulate*](paper/one-postulate.pdf): the paper states the argument, [Lean 4](https://lean-lang.org/) supplies proof authority for the exact algebraic claims, and the Wolfram and SymPy notebooks make the story explorable.

<p align="center">
  <img src="wolfram/assets/notebook_preview_branches.svg" alt="The three kinematic universes allowed by the relativity principle" width="900" />
</p>
<p align="center">
  <sub>The relativity principle permits a one-parameter family of universes. The paper's claim is that the symmetry rules themselves eliminate two of the three branches.</sub>
</p>
<p align="center">
  <sub><strong>Observation tells us the value of the speed. The mathematics tells us that the speed must exist.</strong></sub>
</p>

## Why this matters

Special relativity is usually taught as beginning with two principles:

1. The laws of physics take the same form in all inertial frames.
2. Light travels at the same finite speed in every inertial frame.

The first is a symmetry statement. The second is an empirical statement about one physical phenomenon. The paper asks whether that second statement really had to sit in the foundations.

Einstein's whole career was a campaign against things put in by hand. Special relativity removed absolute simultaneity. General relativity removed privileged coordinate systems. But the invariant speed of light still entered as a physical fact attached to one phenomenon. If the foundational principle is really frame-independence, then the symmetry rules ought to be able to diagnose their own geometry.

This repository's central claim is that they can. If the paper is right, special relativity is more self-contained than Einstein himself could show in 1905: the relativity principle already determines what kind of spacetime is possible, and experiment is only needed to read off the number.

## What this paper does differently

Rather than start with light and derive Lorentzian kinematics from it, the paper starts with the relativity principle together with the standard assumptions of homogeneity, isotropy, and group composition. Those assumptions lead to the familiar one-parameter family

$$
t' = \gamma (t - \kappa v x), \qquad
x' = \gamma (x - vt), \qquad
\gamma = \frac{1}{\sqrt{1 - \kappa v^2}}.
$$

This is the family found in the one-postulate derivations going back to Ignatowski (1910), sharpened later by [Bacry and Levy-Leblond (1968)](https://www.osti.gov/biblio/4838778), Levy-Leblond (1976), Mermin (1984), [Pal (2003)](https://arxiv.org/abs/physics/0302045), and [Anker and Ziegler (2020)](https://arxiv.org/abs/2007.09301). What those derivations leave open is the sign and physical meaning of `kappa`.

The paper's move is to stop where that literature stopped and then go one step further. First classify the possible universes. Then ask whether the algebra can examine itself and select among them. That is where the Killing form becomes decisive.

## From one postulate to three possible universes

Once `kappa` appears, three broad possibilities open up. `kappa` is best read as a single dial controlling what kind of universe you get. Turn it one way and you get Einstein's universe. Leave it at zero and you get Newton's. Turn it the other way and you get a world with no causal order at all.

| Branch | What the transformations describe | What kind of spacetime it gives |
| --- | --- | --- |
| `kappa < 0` | Boosts behave like rotations in a compact geometry | Euclidean four-geometry with no lightcones and no causal distinction between past and future |
| `kappa = 0` | The mixing of space into time disappears | Galilean kinematics with absolute time, no invariant speed, and no unified spacetime metric |
| `kappa > 0` | Space and time mix with a finite limiting speed | Lorentzian spacetime with lightcones, causality, and a real invariant speed |

The standard historical conclusion is that the first postulate alone reaches this three-way fork but cannot decide among the branches. The paper's claim is stronger: once the algebra is allowed to test its own internal structure, only one branch remains compatible with the symmetry principle as a foundational statement.

## Can the rules examine themselves?

The homogeneous kinematics algebra has six generators: three rotations `J_i` and three boosts `K_i`. The paper studies how those generators reshuffle one another under the adjoint action and then applies the algebra's canonical invariant:

$$
B(X,Y) = \mathrm{tr}(\mathrm{ad}_X \circ \mathrm{ad}_Y).
$$

For the `kappa`-family, the result is

$$
B = \mathrm{diag}(-4 I_3,\; 4 \kappa I_3).
$$

That single matrix is the pivot of the argument.

In plain language, the Killing form is the algebra's built-in measuring device. You do not bolt it on later. Every Lie algebra comes with it automatically. When it is non-degenerate, it can distinguish all the directions that matter. When it degenerates, it develops a blind spot.

- The rotation block is always nonzero.
- The boost block is controlled entirely by `kappa`.
- When the boost block vanishes, the algebra is blind to exactly the operations that relate one inertial frame to another.

That last point is why `degenerate` matters here. It does not mean "messy" or "bad" in a vague sense. It means the built-in measuring device fails exactly where the physics lives. In the Galilean case, the blind spot lands on the boosts, which are the generators of changes of velocity. The symmetry can still talk about inertial frames, but it can no longer fully measure the geometry relating them.

<p align="center">
  <img src="wolfram/assets/notebook_preview_killing_form.svg" alt="Preview of the Killing-form view from the Wolfram notebook" width="900" />
</p>
<p align="center">
  <sub>The repository's computational companion makes the same pivot visible: compute the invariant first, then read geometry from it.</sub>
</p>

This is why the Killing form is not an ornamental calculation in the paper. It is the mechanism that tells us whether the symmetry rules can generate their own geometry or whether some part of spacetime has been left as unexplained background structure.

## Three verdicts

**Option 1: `kappa < 0` — the Euclidean universe**

When `kappa` is negative, the Killing form is nondegenerate everywhere, but the resulting group is compact. There is no lightcone structure, no intrinsic distinction between temporal and spatial directions, and no causal ordering of events. The branch is geometrically coherent and physically wrong for a universe with cause and effect.

Verdict: rejected. A universe without causality is not a universe with physics in the ordinary sense.

**Option 2: `kappa = 0` — the Galilean universe**

When `kappa = 0`, the Killing form vanishes on every boost. The boost sector still has shape, but it has no intrinsic ruler. Velocity space has symmetry without a preferred scale, there is no invariant speed, and time survives as fixed background structure rather than being generated by the symmetry. This is why the paper treats Galilean mechanics not as a rival foundation but as a singular limit of the Lorentzian case.

Verdict: rejected. The relativity principle was supposed to make the framework self-contained, but here the algebra cannot finish the job without outside help.

**Option 3: `kappa > 0` — the Lorentzian universe**

When `kappa` is positive, every generator remains visible to the algebra's self-test. The boost sector acquires a definite scale, the invariant speed is finite and real, and spacetime carries a Lorentzian metric rather than separate external notions of space and time. This is the only branch that both preserves causal structure and eliminates background scaffolding.

Verdict: accepted. This is the only branch where the relativity principle is fully implemented rather than partially described.

The paper's comparison table can be read directly from that split:

| Question | `kappa < 0` | `kappa = 0` | `kappa > 0` |
| --- | --- | --- | --- |
| Killing form on boosts | Negative | Zero | Positive |
| Invariant speed | Imaginary | Undefined | Finite and real |
| Spacetime metric | Euclidean | `dt^2` only | Lorentzian |
| Causal structure | None | None | Lightcones |
| Space-time unification | All four directions alike | Impossible | Complete |
| Background structure needed | None | Yes | None |

### The Punchline

1. The relativity principle is the sole postulate.
2. It generates a one-parameter family of possible kinematics, indexed by `kappa`.
3. Every Lie algebra comes with a built-in invariant, the Killing form, for free.
4. At `kappa <= 0`, the self-test fails in one of two ways: either causality disappears or the algebra goes blind on the boost sector.
5. At `kappa > 0`, the self-test remains fully functional: it produces a Lorentzian metric, unifies space and time, and guarantees a finite invariant speed.
6. Therefore a finite, real, universal speed limit is not an empirical bolt-on. Observation determines the value. The algebra determines the existence.

## Structure and scale

The argument does **not** determine the numerical value of the invariant speed. It determines that such a speed must exist.

That is the paper's distinction between structure and calibration:

- The symmetry analysis fixes the architecture.
- Experiment fixes the conversion factor between space and time.
- Measuring `c` tells us that `kappa = 1 / c^2`.

One useful board-game analogy is this: if you demand a self-contained game, the correct board is the one with the ruler already printed on it. You do not postulate the ruler separately. You postulate fairness, and the ruler comes with the winning design. That is the README version of the paper's distinction between structure and calibration.

This is why the paper's closing claim is so sharp: the speed's value is empirical; its existence is not.

Nothing in the physics changes if this argument is right. The Lorentz transformations stay the same. The predictions stay the same. What changes is the logical architecture: special relativity becomes leaner, more self-contained, and closer to Einstein's own instinct that deep theories should not rely on background structure smuggled in by hand.

## Formal verification

The repository formalizes the paper's exact algebraic spine in Lean 4 with Mathlib. The proof development is matrix-first: it writes down explicit generators, proves the bracket table, computes the Killing form, and only then reads off the spacetime consequences.

| Surface | Role | Authority |
| --- | --- | --- |
| [`paper/one-postulate.tex`](paper/one-postulate.tex) and [`paper/one-postulate.pdf`](paper/one-postulate.pdf) | Narrative arc, claim ordering, physical interpretation | Paper |
| [`OnePostulate.lean`](OnePostulate.lean) | Guarded exact proof surface | Lean proof authority |
| [`OnePostulateFull.lean`](OnePostulateFull.lean) | Full-paper root including the deferred classification bridge | Lean proof authority |
| [`wolfram/notebooks/one_postulate_explainer.nb`](wolfram/notebooks/one_postulate_explainer.nb) and [`one_postulate_sympy_colab.ipynb`](one_postulate_sympy_colab.ipynb) | Symbolic checks, diagrams, and interactive explanation | Computed here, not proof authority |

The main Lean modules line up with the paper's stages:

| Lean surface | What it covers |
| --- | --- |
| [`OnePostulate/SpacetimeMatrices.lean`](OnePostulate/SpacetimeMatrices.lean) and [`OnePostulate/KinematicAlgebra.lean`](OnePostulate/KinematicAlgebra.lean) | Explicit generators, bracket table, Jacobi identity |
| [`OnePostulate/KillingForm.lean`](OnePostulate/KillingForm.lean) | `B = diag(-4 I_3, 4 kappa I_3)` and the boost-sector split |
| [`OnePostulate/VelocitySpace.lean`](OnePostulate/VelocitySpace.lean) and [`OnePostulate/SpacetimeRepresentation.lean`](OnePostulate/SpacetimeRepresentation.lean) | Velocity-space metric behavior, spacetime metric invariance, Galilean reducibility, Lorentzian congruence |
| [`OnePostulate/Selection.lean`](OnePostulate/Selection.lean) and [`OnePostulate/ClassificationDerivation.lean`](OnePostulate/ClassificationDerivation.lean) | The branch verdicts and the deferred full-paper classification bridge |

For a deeper walkthrough of the proof spine, see [docs/proof-visuals.md](docs/proof-visuals.md). For notebook workflow, assets, and presentation guidance, see [docs/notebooks.md](docs/notebooks.md). Repository-specific external validation workflows live under [docs/aristotle/README.md](docs/aristotle/README.md), and project-scoped Gauss/OpenGauss setup is documented in [documentation.md](documentation.md).

## Explore the mathematics

The repository includes two computational companions:

- Primary public-facing notebook: [`wolfram/notebooks/one_postulate_explainer.nb`](wolfram/notebooks/one_postulate_explainer.nb), generated from [`wolfram/build_one_postulate_notebook.wl`](wolfram/build_one_postulate_notebook.wl)
- Secondary notebook: [`one_postulate_sympy_colab.ipynb`](one_postulate_sympy_colab.ipynb) [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Intelligent-Internet/ii-research-one-postulate/blob/main/one_postulate_sympy_colab.ipynb)

<p align="center">
  <img src="wolfram/assets/notebook_preview_crosswalk.svg" alt="Paper to notebook to Lean crosswalk" width="900" />
</p>
<p align="center">
  <sub>The notebook surfaces mirror the paper's rhetorical order while keeping Lean as the proof boundary.</sub>
</p>

Suggested reading order:

1. Start with the paper: [`paper/one-postulate.pdf`](paper/one-postulate.pdf)
2. Use the proof guide: [docs/proof-visuals.md](docs/proof-visuals.md)
3. Open the notebook guide: [docs/notebooks.md](docs/notebooks.md)
4. Explore the Wolfram or SymPy companion
5. Drop into [`OnePostulate.lean`](OnePostulate.lean) if you want the exact proof surface

## How this relates to prior work

The README follows the paper's claim, but the paper itself sits inside a long "relativity without light" conversation:

| Year | Reference | Role in this repository's story |
| --- | --- | --- |
| 1888 | Wilhelm Killing, *Die Zusammensetzung der stetigen endlichen Transformationsgruppen* | Introduces the Killing form that becomes the paper's decisive self-test |
| 1905 | [Albert Einstein, *On the Electrodynamics of Moving Bodies*](https://en.wikisource.org/wiki/On_the_Electrodynamics_of_Moving_Bodies_%281920_edition%29) | States the two-postulate presentation of special relativity |
| 1910 | W. von Ignatowski, *Einige allgemeine Bemerkungen uber das Relativitatsprinzip* | Shows that the relativity principle already leads to a one-parameter kinematic family |
| 1921 | Wolfgang Pauli, *Theory of Relativity* | Canonical early statement that `kappa` cannot be fixed without experiment |
| 1968 | [H. Bacry and J.-M. Levy-Leblond, *Possible Kinematics*](https://www.osti.gov/biblio/4838778) | Classifies the possible kinematic groups and sharpens the one-parameter picture |
| 1976 | J.-M. Levy-Leblond, *One More Derivation of the Lorentz Transformation* | Classic pedagogical statement of how far the first postulate goes before branch selection |
| 1984 | N. David Mermin, *Relativity Without Light* | Clear modern presentation of the one-postulate tradition that this paper tries to complete |
| 2003 | [P. B. Pal, *Nothing but Relativity*](https://arxiv.org/abs/physics/0302045) | Modern derivation of Lorentz transformations without assuming light at the start |
| 2015 | [A. Drory, *The necessity of the second postulate in special relativity*](https://arxiv.org/abs/1412.4018) | Frames the modern debate over how much the second postulate contributes physically |
| 2020 | [J.-P. Anker and F. Ziegler, *Relativity without light: A new proof of Ignatowski's theorem*](https://arxiv.org/abs/2007.09301) | Shows the one-postulate route remains mathematically active and technically fertile |

This repository's contribution is not another derivation of the `kappa` family. Its claim is that the family's internal invariant already chooses the physically acceptable branch.

## Build and repository map

Build the local proof and notebook surfaces from the repository root:

```bash
lake build
lake env lean OnePostulate/ClassificationDerivation.lean
lake env lean OnePostulateFull.lean
rg -n 'sorry|admit' OnePostulateFull.lean OnePostulate.lean OnePostulate/*.lean
wolframscript -file wolfram/build_one_postulate_notebook.wl
```

Key repository surfaces:

```text
paper/                    Paper source and PDF
OnePostulate/             Lean proof modules
OnePostulate.lean         Guarded exact root
OnePostulateFull.lean     Full-paper root
docs/proof-visuals.md     Proof-map and theorem spine
docs/notebooks.md         Notebook workflow and asset guide
docs/aristotle/           External validation workflows and archived runs
wolfram/                  Notebook builder, generated notebook, SVG previews
one_postulate_sympy_colab.ipynb   Secondary SymPy companion
documentation.md          Retrieval-oriented repo context
```

## References

- Emad Mostaque (2026), [*One Postulate*](paper/one-postulate.pdf)
- [Albert Einstein (1905/1920 translation), *On the Electrodynamics of Moving Bodies*](https://en.wikisource.org/wiki/On_the_Electrodynamics_of_Moving_Bodies_%281920_edition%29)
- Wilhelm Killing (1888), *Die Zusammensetzung der stetigen endlichen Transformationsgruppen*
- W. von Ignatowski (1910), *Einige allgemeine Bemerkungen uber das Relativitatsprinzip*
- Wolfgang Pauli (1921/1958), *Theory of Relativity*
- [H. Bacry and J.-M. Levy-Leblond (1968), *Possible Kinematics*](https://www.osti.gov/biblio/4838778)
- J.-M. Levy-Leblond (1976), *One More Derivation of the Lorentz Transformation*
- N. David Mermin (1984), *Relativity Without Light*
- [P. B. Pal (2003), *Nothing but Relativity*](https://arxiv.org/abs/physics/0302045)
- [A. Drory (2015), *The necessity of the second postulate in special relativity*](https://arxiv.org/abs/1412.4018)
- [J.-P. Anker and F. Ziegler (2020), *Relativity without light: A new proof of Ignatowski's theorem*](https://arxiv.org/abs/2007.09301)

## Execution Surface / TODO

This is the live execution checklist for the public-facing repository surface.

- [ ] Add D3 and SVG animations.
- [x] Expand Wolfram/Mathematica simulations and Observable D3.
- [ ] Map to interactive website experience.
- [ ] Add license and attribution.
- [ ] Add backlinks to II website + blogs.
- [ ] Add social buttons to README.
- [ ] Human factors and editorial on README content.
- [x] 2026-03-31 `6b6fa14`: Upgrade the Wolfram notebook workflow, canonical `wolfram/` asset paths, and public docs. Present on `mathematica-sympy-one-postulate`.
- [x] 2026-03-30 `91880ef`: Fix Mermaid labels so GitHub renders the proof diagrams correctly. Current branch only.
- [x] 2026-03-30 `fae4848`: Refresh the public docs and notebook surfaces, including the landing-page README, proof visuals, notebook guide, Wolfram companion notebook, and preview assets. Current branch only.
- [x] 2026-03-29 `46309e7`: Archive Aristotle validation bundles as tracked tarballs. Present only on `origin/aristotle-one-postulate`.
- [x] 2026-03-29 `04b2de7` / `9b8d8b8`: Add a paper-aligned narrative to the SymPy notebook. Shared across the SymPy, Aristotle, and current branch lines.
- [x] 2026-03-28 `3d819f2`: Rewrite the README as a narrative overview. Shared across the docs-oriented branch lines.
- [x] 2026-03-28 `11d7901`: Update the paper and archive the current Aristotle validation runs.
- [x] 2026-03-28 `ca63e19`: Archive the Aristotle main-surface validation run.
- [x] 2026-03-27 `33b22f1`: Archive the Aristotle full-paper validation run.
- [x] 2026-03-27 `a872df5`: Improve the README documentation.
- [x] 2026-03-27 `7e604b9`: Add repository-specific Aristotle documentation.
- [x] 2026-03-27 `176dd3e`: Add the full-paper `OnePostulateFull` surface and the deferred classification bridge.
- [x] 2026-03-27 `7c22460`: Close out the phase-1 branch guards and validation hardening docs.
- [x] 2026-03-26 `b67c260`: Complete the phase-1 formal fixes.
- [x] 2026-03-26 `5c83dca`: Repair the phase-1 Lean surface baseline.
