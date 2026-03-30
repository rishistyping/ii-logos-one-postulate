repoRoot = DirectoryName[DirectoryName[ExpandFileName[$InputFileName]]];
If[repoRoot === "." || repoRoot === "" || repoRoot === $Failed, repoRoot = Directory[]];
SetDirectory[repoRoot];

notebooksDir = FileNameJoin[{repoRoot, "notebooks"}];
assetsDir = FileNameJoin[{repoRoot, "docs", "assets"}];
CreateDirectory[notebooksDir, CreateIntermediateDirectories -> True];
CreateDirectory[assetsDir, CreateIntermediateDirectories -> True];

makeTextCell[text_] := Cell[text, "Text"];
makeInputCell[expr_] := Cell[BoxData @ ToBoxes[expr, StandardForm], "Input"];

introCells = {
  Cell["One Postulate in Wolfram", "Title"],
  makeTextCell["This workbook is a computational companion to paper/one-postulate.tex. It mirrors the paper's kappa-controlled story, but it does not replace the Lean proof surface."],
  makeTextCell["The goal is to make the symbolic calculations easy to inspect: the transformation law, the bracket family, the Killing form, and the branch split."],
  Cell["Introduction", "Section"],
  makeTextCell["The paper's core claim is structural: the relativity principle leads to a one-parameter family of kinematics, and the Killing form separates that family into Euclidean, Galilean, and Lorentzian branches."],
  makeTextCell["The notebook keeps the proof authority with Lean and the paper, and uses Wolfram only for symbolic exploration."],
  Cell["The kappa-controlled commutator family", "Section"],
  makeInputCell[ClearAll[t, x, v, kappa, gamma, tPrime, xPrime, J, K, killing, boostBlock, spacetimeMetric, c]],
  makeInputCell[gamma = 1/Sqrt[1 - kappa v^2]],
  makeInputCell[tPrime = gamma (t - kappa v x)],
  makeInputCell[xPrime = gamma (x - v t)],
  makeTextCell["This matches the paper's derived 1+1 inertial-frame law. The Galilean limit appears when kappa tends to zero."],
  makeInputCell[Limit[gamma, kappa -> 0]],
  makeInputCell[{Limit[tPrime, kappa -> 0], Limit[xPrime, kappa -> 0]}],
  Cell["Explicit bracket calculations", "Section"],
  makeTextCell["The notebook adopts the standard homogeneous kinematics algebra used later in the paper, with the ordered basis (Jx, Jy, Jz, Kx, Ky, Kz)."],
  makeInputCell[boostBlock = 4 kappa IdentityMatrix[3]],
  makeInputCell[killing = DiagonalMatrix[Join[ConstantArray[-4, 3], ConstantArray[4 kappa, 3]]]],
  makeInputCell[MatrixForm[killing]],
  Cell["Killing form computation", "Section"],
  makeTextCell["The point of the computation is not the number 4 by itself. The decisive fact is that the rotation block stays nonzero while the boost block scales with kappa."],
  makeInputCell[Det[killing]],
  makeInputCell[Eigenvalues[killing]],
  Cell["Boost-sector and spacetime consequences", "Section"],
  makeInputCell[spacetimeMetric = DiagonalMatrix[{1, -kappa, -kappa, -kappa}]],
  makeInputCell[MatrixForm[spacetimeMetric]],
  makeTextCell["For kappa > 0, the paper reads this as a Lorentzian branch with a finite invariant speed. For kappa = 0, the boost sector degenerates and the absolute-time direction survives."],
  makeInputCell[c = 1/Sqrt[kappa]],
  makeInputCell[Limit[c, kappa -> 0, Direction -> "FromAbove"]],
  Cell["Branch comparison", "Section"],
  makeInputCell[Grid[{
      {"Regime", "Symbolic consequence", "Paper interpretation"},
      {"kappa < 0", "boost block negative definite; no real singular speed", "Euclidean branch"},
      {"kappa = 0", "boost block vanishes; Galilean limit holds", "Galilean branch"},
      {"kappa > 0", "finite real singular speed at 1/Sqrt[kappa]", "Lorentzian branch"}
    }, Frame -> All, Background -> {None, {{Lighter[Gray, .95], White}}}]],
  Cell["Lean crosswalk", "Section"],
  makeTextCell["The notebook's symbolic checkpoints correspond to Lean modules and theorems, but Lean remains the proof authority."],
  makeInputCell[Grid[{
      {"Notebook topic", "Lean anchor"},
      {"Transformation law and Galilean limit", "OnePostulate/SpacetimeMatrices.lean"},
      {"Bracket family", "matrix_bracket_JJ / JK / KK; kinematic_bracket_table"},
      {"Killing form", "killing_form_diag; boost_killing_form_eq"},
      {"Boost and spacetime branches", "killing_restricts_to_metric; spacetime_metric_invariant; phase1_selection_summary"}
    }, Frame -> All, Background -> {None, {{Lighter[Gray, .95], White}}}]],
  Cell["Proof authority note", "Section"],
  makeTextCell["Computed or symbolically checked here means: the notebook evaluates the formulas it already states. Formalized in Lean means: the repository proves the corresponding claims in the Lean modules. The notebook never widens the proof surface."],
  Cell["What the notebook proves and what the paper concludes", "Section"],
  makeTextCell["The paper ends by distinguishing structural determination from empirical calibration. The notebook preserves that distinction explicitly."],
  makeInputCell[Column[{
      Style["Symbolically checked here", Bold],
      {
        "Galilean limit t' = t and x' = x - v t as kappa -> 0",
        "Killing form diag(-4 I3, 4 kappa I3)",
        "Boost block = 4 kappa I3",
        "Metric diag(1, -kappa, -kappa, -kappa)"
      },
      Style["Formalized in Lean", Bold],
      {
        "matrix_bracket_JJ / matrix_bracket_JK / matrix_bracket_KK",
        "kinematic_bracket_table",
        "killing_form_diag",
        "boost_killing_form_eq",
        "killing_restricts_to_metric",
        "spacetime_metric_invariant",
        "phase1_selection_summary"
      }
    }, Spacings -> 1]]
};

nb = Notebook[
  introCells,
  StyleDefinitions -> "Default.nb",
  WindowTitle -> "One Postulate in Wolfram",
  TaggingRules -> <|"Repository" -> "one-postulate-lean"|>
];

notebookPath = FileNameJoin[{notebooksDir, "one_postulate_explainer.nb"}];
Export[notebookPath, nb, "NB"];

branchGraphic = Graphics[
  {
    EdgeForm[Directive[RGBColor[0.33, 0.38, 0.46], Thick]],
    FaceForm[RGBColor[0.92, 0.95, 0.98]],
    RoundedRectangle[{0.1, 0.75}, {0.9, 0.95}, 0.03],
    FaceForm[RGBColor[0.97, 0.93, 0.84]],
    RoundedRectangle[{1.55, 0.15}, {2.55, 0.45}, 0.03],
    FaceForm[RGBColor[0.92, 0.96, 0.90]],
    RoundedRectangle[{1.55, 0.75}, {2.55, 1.05}, 0.03],
    FaceForm[RGBColor[0.97, 0.89, 0.89]],
    RoundedRectangle[{1.55, 1.35}, {2.55, 1.65}, 0.03],
    GrayLevel[0.28], Arrowheads[0.03],
    Arrow[{{0.9, 0.85}, {1.45, 0.25}}],
    Arrow[{{0.9, 0.85}, {1.45, 0.9}}],
    Arrow[{{0.9, 0.85}, {1.45, 1.5}}],
    Text[Style["kappa", 22, Bold, RGBColor[0.16, 0.23, 0.37]], {0.5, 0.85}],
    Text[Style["kappa < 0", 18, Bold, RGBColor[0.55, 0.34, 0.06]], {2.05, 0.3}],
    Text[Style["kappa = 0", 18, Bold, RGBColor[0.08, 0.46, 0.31]], {2.05, 0.9}],
    Text[Style["kappa > 0", 18, Bold, RGBColor[0.60, 0.12, 0.12]], {2.05, 1.5}]
  },
  ImageSize -> 720,
  PlotRange -> {{0, 2.75}, {0, 1.9}},
  Background -> White
];

killingGraphic = Graphics[
  {
    EdgeForm[Directive[RGBColor[0.29, 0.33, 0.40], Thick]],
    FaceForm[RGBColor[0.88, 0.92, 0.98]],
    Rectangle[{0.12, 0.55}, {1.45, 1.25}],
    FaceForm[RGBColor[0.90, 0.97, 0.93]],
    Rectangle[{1.75, 0.55}, {3.08, 1.25}],
    GrayLevel[0.2], Thick,
    Arrow[{{0.75, 1.48}, {0.75, 1.28}}],
    Arrow[{{2.41, 1.48}, {2.41, 1.28}}],
    Text[Style["rotation block", 18, Bold, RGBColor[0.11, 0.28, 0.50]], {0.79, 1.67}],
    Text[Style["boost block", 18, Bold, RGBColor[0.06, 0.43, 0.30]], {2.41, 1.67}],
    Text[Style["-4 I3", 30, Bold, RGBColor[0.11, 0.28, 0.50]], {0.78, 0.92}],
    Text[Style["4 kappa I3", 30, Bold, RGBColor[0.06, 0.43, 0.30]], {2.41, 0.92}],
    Text[Style["B = diag(-4 I3, 4 kappa I3)", 22, Bold, RGBColor[0.18, 0.18, 0.18]], {1.62, 0.22}]
  },
  ImageSize -> 760,
  PlotRange -> {{0, 3.2}, {0, 1.95}},
  Background -> White
];

spacetimeGraphic = Graphics[
  {
    EdgeForm[Directive[RGBColor[0.33, 0.38, 0.46], Thick]],
    FaceForm[RGBColor[0.97, 0.95, 0.88]],
    Rectangle[{0.12, 0.55}, {3.12, 1.3}],
    GrayLevel[0.22], Thick,
    Text[Style["g = diag(1, -kappa, -kappa, -kappa)", 24, Bold, RGBColor[0.31, 0.21, 0.06]], {1.62, 1.66}],
    Text[Style["kappa = 0", 20, Bold, RGBColor[0.12, 0.46, 0.31]], {0.88, 0.95}],
    Text[Style["absolute time survives", 18, RGBColor[0.12, 0.46, 0.31]], {0.88, 0.72}],
    Text[Style["kappa > 0", 20, Bold, RGBColor[0.60, 0.12, 0.12]], {2.35, 0.95}],
    Text[Style["Lorentzian branch", 18, RGBColor[0.60, 0.12, 0.12]], {2.35, 0.72}],
    Arrowheads[0.03],
    Arrow[{{1.55, 1.35}, {1.55, 1.72}}],
    Text[Style["branch selection follows from the invariant form", 16, GrayLevel[0.25]], {1.62, 0.42}]
  },
  ImageSize -> 760,
  PlotRange -> {{0, 3.25}, {0, 2.0}},
  Background -> White
];

Export[FileNameJoin[{assetsDir, "notebook_preview_branches.svg"}], branchGraphic];
Export[FileNameJoin[{assetsDir, "notebook_preview_killing_form.svg"}], killingGraphic];
Export[FileNameJoin[{assetsDir, "notebook_preview_spacetime.svg"}], spacetimeGraphic];

Print["Wrote ", notebookPath];
Print["Wrote preview SVG assets to ", assetsDir];
