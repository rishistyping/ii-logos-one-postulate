repoRoot = DirectoryName[DirectoryName[ExpandFileName[$InputFileName]]];
If[repoRoot === "." || repoRoot === "" || repoRoot === $Failed, repoRoot = Directory[]];
SetDirectory[repoRoot];

wolframDir = FileNameJoin[{repoRoot, "wolfram"}];
notebooksDir = FileNameJoin[{wolframDir, "notebooks"}];
assetsDir = FileNameJoin[{wolframDir, "assets"}];

If[! DirectoryQ[notebooksDir],
  CreateDirectory[notebooksDir, CreateIntermediateDirectories -> True]
];
If[! DirectoryQ[assetsDir],
  CreateDirectory[assetsDir, CreateIntermediateDirectories -> True]
];

ClearAll[kappa, v, t, x];
$Assumptions = Element[v | t | x, Reals];

colors = <|
  "Background" -> RGBColor["#F7F4EE"],
  "Card" -> RGBColor["#FFFDF9"],
  "Text" -> RGBColor["#22252B"],
  "Slate" -> RGBColor["#6B7584"],
  "Lorentz" -> RGBColor["#2457A6"],
  "Galilean" -> RGBColor["#2E7D6D"],
  "Euclidean" -> RGBColor["#B86A2E"],
  "SoftLorentz" -> RGBColor["#E8F0FF"],
  "SoftGalilean" -> RGBColor["#E4F3EF"],
  "SoftEuclidean" -> RGBColor["#F8ECDD"],
  "SoftSlate" -> RGBColor["#EDF0F4"]
|>;

baseLabelStyle = Directive[colors["Text"], FontFamily -> "Helvetica", FontSize -> 13];
smallLabelStyle = Directive[colors["Text"], FontFamily -> "Helvetica", FontSize -> 11];
sectionTitleStyle = Directive[colors["Text"], FontFamily -> "Helvetica", FontSize -> 26, Bold];
cardTitleStyle[color_] := Directive[color, FontFamily -> "Helvetica", FontSize -> 18, Bold];
heroTitleStyle = Directive[colors["Text"], FontFamily -> "Helvetica", FontSize -> 24, Bold];

makeTextCell[text_] := Cell[text, "Text"];
makeSectionCell[text_] := Cell[text, "Section"];
makeSubsectionCell[text_] := Cell[text, "Subsection"];

codeCell[expr_] := Cell[BoxData @ ToBoxes @ Defer[expr], "Input"];

codeResultGroup[expr_] := Module[
  {result = Quiet @ Check[expr, $Failed]},
  Cell[CellGroupData[{
    codeCell[expr],
    Cell[BoxData @ ToBoxes[result, StandardForm], "Output"]
  }, Open]]
];

outputCell[expr_] := Cell[BoxData @ ToBoxes[expr, StandardForm], "Output"];

gammaExpr[k_] := 1/Sqrt[1 - k v^2];
tPrimeExpr[k_] := gammaExpr[k] (t - k v x);
xPrimeExpr[k_] := gammaExpr[k] (x - v t);
killingFormMatrixExpr[k_] := DiagonalMatrix[Join[ConstantArray[-4, 3], ConstantArray[4 k, 3]]];
boostBlockExpr[k_] := DiagonalMatrix[ConstantArray[4 k, 3]];
spacetimeMetricExpr[k_] := DiagonalMatrix[{1, -k, -k, -k}];
velocityMetricExpr[k_] := DiagonalMatrix[ConstantArray[4 k, 3]];
lorentzCongruenceExpr[k_] := DiagonalMatrix[{1, 1/Sqrt[k], 1/Sqrt[k], 1/Sqrt[k]}];
invariantSpeedSquaredExpr[k_] := 1/k;

branchName[k_] := Piecewise[{
   {"Euclidean branch", k < 0},
   {"Galilean branch", k == 0},
   {"Lorentzian branch", k > 0}
  }];

branchColor[k_] := Which[k < 0, colors["Euclidean"], k == 0, colors["Galilean"], True, colors["Lorentz"]];
branchFill[k_] := Which[k < 0, colors["SoftEuclidean"], k == 0, colors["SoftGalilean"], True, colors["SoftLorentz"]];

withCaption[content_, caption_] := Column[
  {
    content,
    Style[caption, FontFamily -> "Helvetica", FontSize -> 11, colors["Slate"]]
  },
  Spacings -> 0.5
];

lightconeThumbnail[color_] := Graphics[
  {
    colors["Slate"], AbsoluteThickness[1.4],
    Line[{{0, -1.1}, {0, 1.15}}],
    Line[{{-1.15, 0}, {1.15, 0}}],
    {Directive[Lighter[color, 0.72]], Polygon[{{0, 0}, {-0.78, 1.05}, {0.78, 1.05}}]},
    {Directive[color, AbsoluteThickness[4]], Line[{{0, 0}, {-0.78, 1.05}}], Line[{{0, 0}, {0.78, 1.05}}]}
  },
  PlotRange -> {{-1.2, 1.2}, {-1.2, 1.2}},
  Background -> None,
  ImageSize -> 130
];

simultaneityThumbnail[color_] := Graphics[
  {
    colors["Slate"], AbsoluteThickness[1.4],
    Line[{{0, -1.1}, {0, 1.15}}],
    Line[{{-1.15, 0}, {1.15, 0}}],
    {Directive[color, AbsoluteThickness[3.4]],
      Table[Line[{{-1.0, y}, {1.0, y}}], {y, -0.7, 0.9, 0.4}]}
  },
  PlotRange -> {{-1.2, 1.2}, {-1.2, 1.2}},
  Background -> None,
  ImageSize -> 130
];

rotationThumbnail[color_] := Graphics[
  {
    {Directive[color, AbsoluteThickness[4]], Circle[{0, 0}, 0.84]},
    {Directive[color, AbsoluteThickness[4]],
      Arrow[BezierCurve[{{0.55, -0.66}, {1.08, -0.1}, {0.45, 0.72}}]]},
    Inset[Style["all directions stay geometric", FontFamily -> "Helvetica",
      FontSize -> 10, colors["Slate"]], {0, -1.18}]
  },
  PlotRange -> {{-1.25, 1.25}, {-1.35, 1.15}},
  Background -> None,
  ImageSize -> 130
];

metricMiniPanel[k_, branchLabel_, note_, color_] := Framed[
  Column[
    {
      Style[branchLabel, cardTitleStyle[color]],
      Style[
        Row[{"diag(1, ", If[k === 0, "0", ToString[TraditionalForm[-k]]], ", ",
          If[k === 0, "0", ToString[TraditionalForm[-k]]], ", ",
          If[k === 0, "0", ToString[TraditionalForm[-k]]], ")"}],
        FontFamily -> "Helvetica", FontSize -> 13, colors["Text"]],
      Style[note, FontFamily -> "Helvetica", FontSize -> 11, colors["Slate"]]
    },
    Spacings -> 0.45
  ],
  Background -> Lighter[color, 0.86],
  FrameStyle -> Directive[color, AbsoluteThickness[2]],
  RoundingRadius -> 10,
  FrameMargins -> {{14, 14}, {10, 10}},
  ImageSize -> {210, Automatic}
];

branchCard[title_, subtitle_, thumbnail_, bullets_, color_, fill_] := Framed[
  Column[
    Join[
      {
        Style[title, cardTitleStyle[color]],
        Style[subtitle, FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
        thumbnail
      },
      (Style[#, FontFamily -> "Helvetica", FontSize -> 11, colors["Text"]] &) /@
        (Row[{"• ", #}] & /@ bullets)
    ],
    Spacings -> 0.55,
    Alignment -> Left
  ],
  Background -> fill,
  FrameStyle -> Directive[color, AbsoluteThickness[2]],
  RoundingRadius -> 12,
  FrameMargins -> {{16, 16}, {14, 14}},
  ImageSize -> {255, 300}
];

kappaBranchGraphic = Graphics[
  {
    Inset[
      Framed[
        Column[{
          Style["one parameter", cardTitleStyle[colors["Slate"]]],
          Style["The paper's transformation family is controlled by a single real number kappa.",
            baseLabelStyle],
          Style[
            Row[{
              "gamma = ", TraditionalForm[gammaExpr[kappa]], "\n",
              "t' = ", TraditionalForm[tPrimeExpr[kappa]], "\n",
              "x' = ", TraditionalForm[xPrimeExpr[kappa]]
            }],
            FontFamily -> "Helvetica", FontSize -> 13, colors["Text"]]
        }, Spacings -> 0.6, Alignment -> Left],
        Background -> colors["Card"],
        FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[2]],
        RoundingRadius -> 12,
        FrameMargins -> {{16, 16}, {16, 16}},
        ImageSize -> {280, 220}
      ],
      {1.8, 2.4}
    ],
    {Directive[colors["Slate"], AbsoluteThickness[2.4], Arrowheads[0.03]],
      Arrow[{{3.35, 2.8}, {4.25, 4.85}}],
      Arrow[{{3.35, 2.4}, {4.25, 2.4}}],
      Arrow[{{3.35, 2.0}, {4.25, 0.9}}]},
    Inset[
      branchCard[
        "kappa > 0",
        "Lorentzian branch",
        lightconeThumbnail[colors["Lorentz"]],
        {
          "boost block 4 kappa I3 is positive",
          "finite real invariant speed 1/Sqrt[kappa]",
          "spacetime interval mixes time and space"
        },
        colors["Lorentz"],
        colors["SoftLorentz"]
      ],
      {6.2, 4.85}
    ],
    Inset[
      branchCard[
        "kappa = 0",
        "Galilean branch",
        simultaneityThumbnail[colors["Galilean"]],
        {
          "boost block vanishes exactly",
          "Galilean limit gives t' = t",
          "absolute time survives as background structure"
        },
        colors["Galilean"],
        colors["SoftGalilean"]
      ],
      {6.2, 2.4}
    ],
    Inset[
      branchCard[
        "kappa < 0",
        "Euclidean branch",
        rotationThumbnail[colors["Euclidean"]],
        {
          "boost block 4 kappa I3 is negative",
          "no real invariant speed emerges",
          "time is not singled out from geometry"
        },
        colors["Euclidean"],
        colors["SoftEuclidean"]
      ],
      {6.2, 0.0}
    ]
  },
  PlotRange -> {{0, 8.1}, {-1.0, 5.8}},
  Background -> colors["Background"],
  ImageSize -> 980
];

killingGraphic = Graphics[
  {
    Inset[
      Framed[
        Column[{
          Style["Computing the Killing form", cardTitleStyle[colors["Text"]]],
          Style["The decisive invariant appears as a 6 x 6 block diagonal matrix.", baseLabelStyle],
          Style[TraditionalForm[killingFormMatrixExpr[kappa]], FontFamily -> "Helvetica", FontSize -> 16, colors["Text"]],
          Style["Rotation block stays fixed at -4 I3 while the boost block scales with kappa.", smallLabelStyle]
        }, Spacings -> 0.7, Alignment -> Left],
        Background -> colors["Card"],
        FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[2]],
        RoundingRadius -> 12,
        FrameMargins -> {{18, 18}, {16, 16}},
        ImageSize -> {340, 220}
      ],
      {2.15, 2.2}
    ],
    Inset[
      Framed[
        Column[{
          Style["rotation block", cardTitleStyle[colors["Slate"]]],
          Style["-4 I3", FontFamily -> "Helvetica", FontSize -> 28, Bold, colors["Text"]],
          Style["Always nonzero", baseLabelStyle]
        }, Spacings -> 0.45, Alignment -> Center],
        Background -> colors["SoftSlate"],
        FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[2]],
        RoundingRadius -> 12,
        FrameMargins -> {{16, 16}, {16, 16}},
        ImageSize -> {200, 180}
      ],
      {5.05, 2.75}
    ],
    Inset[
      Framed[
        Column[{
          Style["boost block", cardTitleStyle[colors["Lorentz"]]],
          Style["4 kappa I3", FontFamily -> "Helvetica", FontSize -> 28, Bold, colors["Text"]],
          Style["This is the sign-changing pivot of the whole story.", baseLabelStyle]
        }, Spacings -> 0.45, Alignment -> Center],
        Background -> colors["SoftLorentz"],
        FrameStyle -> Directive[colors["Lorentz"], AbsoluteThickness[2]],
        RoundingRadius -> 12,
        FrameMargins -> {{16, 16}, {16, 16}},
        ImageSize -> {220, 180}
      ],
      {7.45, 2.75}
    ],
    {Directive[colors["Slate"], AbsoluteThickness[2.4], Arrowheads[0.035]],
      Arrow[{{3.95, 2.55}, {4.55, 2.7}}],
      Arrow[{{6.1, 2.7}, {6.6, 2.7}}]},
    Inset[
      Framed[
        Grid[
          {
            {"kappa < 0", "negative boost block", "compact / Euclidean verdict"},
            {"kappa = 0", "zero boost block", "degenerate Galilean verdict"},
            {"kappa > 0", "positive boost block", "Lorentzian verdict"}
          },
          Background -> {
            None,
            {
              colors["SoftEuclidean"],
              colors["SoftGalilean"],
              colors["SoftLorentz"]
            }
          },
          Dividers -> {All, All},
          Alignment -> Left,
          ItemStyle -> {
            Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
            Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
            Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]]
          },
          Spacings -> {1.1, 0.9}
        ],
        Background -> colors["Card"],
        FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[2]],
        RoundingRadius -> 10,
        FrameMargins -> {{12, 12}, {10, 10}},
        ImageSize -> {520, Automatic}
      ],
      {5.95, 0.58}
    ]
  },
  PlotRange -> {{0.2, 8.6}, {-0.4, 3.8}},
  Background -> colors["Background"],
  ImageSize -> 980
];

spacetimeGraphic = Graphics[
  {
    Inset[
      Framed[
        Column[{
          Style["Spacetime metric consequences", cardTitleStyle[colors["Text"]]],
          Style[
            Row[{"g = ", TraditionalForm[spacetimeMetricExpr[kappa]]}],
            FontFamily -> "Helvetica", FontSize -> 16, colors["Text"]],
          Style["The same parameter that scales the boost block also controls the invariant quadratic form.", baseLabelStyle]
        }, Spacings -> 0.65, Alignment -> Left],
        Background -> colors["Card"],
        FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[2]],
        RoundingRadius -> 12,
        FrameMargins -> {{18, 18}, {16, 16}},
        ImageSize -> {360, 200}
      ],
      {2.45, 2.65}
    ],
    Inset[metricMiniPanel[-1/2, "Euclidean", "No null directions survive.", colors["Euclidean"]], {5.65, 3.05}],
    Inset[metricMiniPanel[0, "Galilean", "Only dt^2 remains canonical.", colors["Galilean"]], {5.65, 1.9}],
    Inset[metricMiniPanel[1/2, "Lorentzian", "Congruent to diag(1,-1,-1,-1).", colors["Lorentz"]], {5.65, 0.75}],
    {Directive[colors["Slate"], AbsoluteThickness[2.2], Arrowheads[0.03]],
      Arrow[{{3.95, 2.6}, {4.55, 3.0}}],
      Arrow[{{3.95, 2.35}, {4.55, 1.9}}],
      Arrow[{{3.95, 2.1}, {4.55, 0.8}}]}
  },
  PlotRange -> {{0.2, 8.4}, {0.0, 4.0}},
  Background -> colors["Background"],
  ImageSize -> 980
];

crosswalkRows = {
  {"One parameter, three worlds",
    "Galilean limit and branch visual",
    "OnePostulate/SpacetimeMatrices.lean; OnePostulate/Selection.lean",
    "paper plus Lean"},
  {"Kinematic bracket family",
    "commutator table and boost block scaling",
    "matrix_bracket_JJ; matrix_bracket_JK; matrix_bracket_KK; kinematic_bracket_table; boostCommutator_scales_with_kappa",
    "Lean"},
  {"Killing form pivot",
    "diag(-4 I3, 4 kappa I3), determinant, eigenvalues",
    "killing_form_diag; boost_killing_form_eq; boost_killing_nondegenerate_iff_kappa_ne_zero",
    "Lean"},
  {"Velocity and spacetime consequences",
    "1/kappa, spacetime metric, Lorentz congruence",
    "killing_restricts_to_metric; invariantSpeedSquared_formula; spacetime_metric_eq_diagonal; spacetime_metric_invariant; spacetime_metric_congruent_stdLorentz_of_kappa_pos; phase1_selection_summary; classification_derivation_complete",
    "Lean plus paper framing"}
};

crosswalkGraphic = Framed[
  Column[
    {
      Style["Notebook to Lean crosswalk", cardTitleStyle[colors["Text"]]],
      Grid[
        Prepend[crosswalkRows, {"Narrative stage", "Computed / visualized here", "Lean anchors", "Source of authority"}],
        Background -> {
          {colors["SoftSlate"], None, None, None, None},
          {
            colors["SoftSlate"],
            colors["SoftLorentz"],
            colors["SoftGalilean"],
            colors["SoftEuclidean"],
            colors["SoftSlate"]
          }
        },
        Dividers -> {All, All},
        Alignment -> Left,
        ItemStyle -> {
          Directive[FontFamily -> "Helvetica", FontSize -> 12, Bold, colors["Text"]],
          Directive[FontFamily -> "Helvetica", FontSize -> 11, colors["Text"]],
          Directive[FontFamily -> "Helvetica", FontSize -> 11, colors["Text"]],
          Directive[FontFamily -> "Helvetica", FontSize -> 11, colors["Text"]],
          Directive[FontFamily -> "Helvetica", FontSize -> 11, colors["Text"]]
        },
        ItemSize -> {{14, 18, 28, 12}, Automatic},
        Spacings -> {1.0, 0.9}
      ]
    },
    Spacings -> 0.8
  ],
  Background -> colors["Card"],
  FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[2]],
  RoundingRadius -> 12,
  FrameMargins -> {{16, 16}, {16, 16}},
  ImageSize -> 1100
];

heroGraphic = Graphics[
  {
    Inset[
      Style["One parameter, three worlds", heroTitleStyle],
      {4.8, 5.15}
    ],
    Inset[
      Style[
        "The relativity postulate yields a kappa-family. The Killing form reads the family before geometry is interpreted.",
        FontFamily -> "Helvetica", FontSize -> 14, colors["Slate"]],
      {4.8, 4.72}
    ],
    Inset[
      Framed[
        Column[{
          Style["kappa controls the family", cardTitleStyle[colors["Slate"]]],
          Style[TraditionalForm[{tPrimeExpr[kappa], xPrimeExpr[kappa]}], FontFamily -> "Helvetica",
            FontSize -> 12, colors["Text"]],
          Style["kappa -> 0 recovers the Galilean limit", smallLabelStyle]
        }, Spacings -> 0.5, Alignment -> Left],
        Background -> colors["Card"],
        FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[2]],
        RoundingRadius -> 12,
        FrameMargins -> {{14, 14}, {12, 12}},
        ImageSize -> {250, 170}
      ],
      {1.55, 2.85}
    ],
    Inset[
      Framed[
        Column[{
          Style["Killing form pivot", cardTitleStyle[colors["Lorentz"]]],
          Style["diag(-4 I3, 4 kappa I3)", FontFamily -> "Helvetica", FontSize -> 20, Bold, colors["Text"]],
          Style["The boost block changes sign and vanishes only at kappa = 0.", baseLabelStyle]
        }, Spacings -> 0.55, Alignment -> Left],
        Background -> colors["Card"],
        FrameStyle -> Directive[colors["Lorentz"], AbsoluteThickness[2]],
        RoundingRadius -> 12,
        FrameMargins -> {{14, 14}, {12, 12}},
        ImageSize -> {285, 170}
      ],
      {4.8, 2.85}
    ],
    Inset[
      Framed[
        Column[{
          Style["Spacetime consequence summary", cardTitleStyle[colors["Text"]]],
          Style["g = diag(1, -kappa, -kappa, -kappa)", FontFamily -> "Helvetica", FontSize -> 14, colors["Text"]],
          Style["positive kappa -> Lorentzian, zero -> Galilean degeneration, negative -> Euclidean branch", smallLabelStyle]
        }, Spacings -> 0.5, Alignment -> Left],
        Background -> colors["Card"],
        FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[2]],
        RoundingRadius -> 12,
        FrameMargins -> {{14, 14}, {12, 12}},
        ImageSize -> {280, 170}
      ],
      {8.05, 2.85}
    ],
    {Directive[colors["Slate"], AbsoluteThickness[2.5], Arrowheads[0.032]],
      Arrow[{{2.8, 2.85}, {3.3, 2.85}}],
      Arrow[{{6.3, 2.85}, {6.75, 2.85}}]},
    Inset[
      branchCard["kappa < 0", "Euclidean", rotationThumbnail[colors["Euclidean"]],
        {"no null vectors", "compact branch"}, colors["Euclidean"], colors["SoftEuclidean"]],
      {3.05, 0.65}
    ],
    Inset[
      branchCard["kappa = 0", "Galilean", simultaneityThumbnail[colors["Galilean"]],
        {"boost block = 0", "absolute time survives"}, colors["Galilean"], colors["SoftGalilean"]],
      {4.85, 0.65}
    ],
    Inset[
      branchCard["kappa > 0", "Lorentzian", lightconeThumbnail[colors["Lorentz"]],
        {"finite real invariant speed", "Lorentz metric"}, colors["Lorentz"], colors["SoftLorentz"]],
      {6.65, 0.65}
    ]
  },
  PlotRange -> {{0.25, 9.35}, {-1.15, 5.55}},
  Background -> colors["Background"],
  ImageSize -> 1280
];

regimeGraphic[k_] := Framed[
  Grid[
    {
      {
        Style["Selected kappa", cardTitleStyle[branchColor[k]]],
        Style[TraditionalForm[k], FontFamily -> "Helvetica", FontSize -> 18, colors["Text"]]
      },
      {
        Style["Branch", baseLabelStyle],
        Style[branchName[k], FontFamily -> "Helvetica", FontSize -> 15, Bold, branchColor[k]]
      },
      {
        Style["gamma(v)", baseLabelStyle],
        Style[TraditionalForm[gammaExpr[k]], FontFamily -> "Helvetica", FontSize -> 15, colors["Text"]]
      },
      {
        Style["Galilean limit", baseLabelStyle],
        Style[
          TraditionalForm[{Limit[tPrimeExpr[kappa], kappa -> 0], Limit[xPrimeExpr[kappa], kappa -> 0]}],
          FontFamily -> "Helvetica", FontSize -> 14, colors["Text"]]
      }
    },
    Alignment -> Left,
    Spacings -> {1.0, 0.9}
  ],
  Background -> branchFill[k],
  FrameStyle -> Directive[branchColor[k], AbsoluteThickness[2]],
  RoundingRadius -> 10,
  FrameMargins -> {{14, 14}, {10, 10}},
  ImageSize -> {430, Automatic}
];

killingInteractivePanel[k_] := Framed[
  Column[
    {
      Style["Boost block focus", cardTitleStyle[branchColor[k]]],
      Grid[
        {
          {"Boost block", TraditionalForm[boostBlockExpr[k]]},
          {"Determinant of full Killing form", TraditionalForm[Det[killingFormMatrixExpr[k]] // Factor]},
          {"Nondegenerate?", If[k === 0, "No: the boost block vanishes.", "Yes: kappa != 0 keeps the boost block visible."]}
        },
        Alignment -> Left,
        Dividers -> {None, {False, True, True, False}},
        ItemStyle -> {
          Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
          Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]]
        },
        Spacings -> {1.0, 0.8}
      ]
    },
    Spacings -> 0.75
  ],
  Background -> branchFill[k],
  FrameStyle -> Directive[branchColor[k], AbsoluteThickness[2]],
  RoundingRadius -> 10,
  FrameMargins -> {{14, 14}, {12, 12}},
  ImageSize -> {470, Automatic}
];

spacetimeInteractivePanel[k_] := Module[
  {
    speedText = Which[
      k < 0, "1/Sqrt[kappa] is imaginary, so no real invariant speed appears.",
      k == 0, "1/kappa is undefined at kappa = 0, matching the missing velocity-scale ruler.",
      True, "1/Sqrt[kappa] is finite and real, giving a shared invariant speed."
    ],
    congruenceText = Which[
      k < 0, "The metric is positive on every nonzero direction once kappa is negative.",
      k == 0, "The spatial part disappears from the canonical invariant form.",
      True, "Rescaling space by 1/Sqrt[kappa] yields diag(1,-1,-1,-1)."
    ]
  },
  Framed[
    Column[
      {
        Style["Spacetime and velocity consequences", cardTitleStyle[branchColor[k]]],
        Grid[
          {
            {"Metric", TraditionalForm[spacetimeMetricExpr[k]]},
            {"Invariant speed squared", Which[k == 0, "undefined at kappa = 0", True, TraditionalForm[invariantSpeedSquaredExpr[k]]]},
            {"Interpretation", speedText},
            {"Geometry", congruenceText}
          },
          Alignment -> Left,
          Dividers -> {None, {False, True, True, True, False}},
          ItemStyle -> {
            Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
            Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]]
          },
          Spacings -> {1.0, 0.8}
        ]
      },
      Spacings -> 0.7
    ],
    Background -> branchFill[k],
    FrameStyle -> Directive[branchColor[k], AbsoluteThickness[2]],
    RoundingRadius -> 10,
    FrameMargins -> {{14, 14}, {12, 12}},
    ImageSize -> {500, Automatic}
  ]
];

branchComparisonGrid = Grid[
  {
    {"Regime", "Boost block", "Invariant speed", "Spacetime consequence"},
    {"kappa < 0", "4 kappa I3 is negative", "imaginary / no real invariant speed", "Euclidean branch; no nonzero null vectors"},
    {"kappa = 0", "0", "undefined", "absolute time survives; spacetime form degenerates"},
    {"kappa > 0", "4 kappa I3 is positive", "1/Sqrt[kappa] is finite and real", "Lorentzian branch; metric congruent to diag(1,-1,-1,-1)"}
  },
  Background -> {
    None,
    {
      colors["SoftSlate"],
      colors["SoftEuclidean"],
      colors["SoftGalilean"],
      colors["SoftLorentz"]
    }
  },
  Dividers -> All,
  Alignment -> Left,
  ItemStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
  Spacings -> {1.1, 0.9}
];

crosswalkGrid = Grid[
  Prepend[crosswalkRows, {"Narrative stage", "Computed / visualized here", "Lean anchors", "Source of authority"}],
  Background -> {
    {colors["SoftSlate"], None, None, None, None},
    {
      colors["SoftSlate"],
      colors["SoftLorentz"],
      colors["SoftGalilean"],
      colors["SoftEuclidean"],
      colors["SoftSlate"]
    }
  },
  Dividers -> All,
  Alignment -> Left,
  ItemStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 11, colors["Text"]],
  ItemSize -> {{14, 18, 28, 12}, Automatic},
  Spacings -> {1.0, 0.8}
];

notebookCells = {
  Cell["One Postulate in Wolfram", "Title"],
  makeTextCell["This notebook is a public-facing computational companion to the local paper and Lean development. It follows the paper's narrative arc while keeping the proofs in Lean."],
  makeTextCell["It is not a proof-assistant notebook and not a raw symbolic scratchpad. Its job is to compute and visualize the kappa-family clearly enough that a non-Lean reader can see why the Killing form is the pivot."],
  outputCell @ withCaption[
    heroGraphic,
    "Hero overview. One parameter controls the transformation family, the Killing form reads the branch structure, and the spacetime consequences follow afterward."
  ],

  makeSectionCell["What this notebook is for"],
  makeTextCell["Computed or visualized here means: Wolfram evaluates exact limits, matrix formulas, determinants, congruence calculations, and visual summaries of formulas already present in the paper and Lean files."],
  makeTextCell["Formally proved in Lean means: theorem names and proof-structure claims come from local Lean modules, not from Wolfram. Interpretive framing comes from the paper."],

  makeSectionCell["One parameter, three worlds"],
  makeTextCell["The paper's starting point is a single kappa-controlled family of inertial-frame transformations. The sign of kappa is not interpreted first; the notebook computes the shared structure and then reads the branch split from the invariant form."],
  outputCell @ withCaption[
    kappaBranchGraphic,
    "Branch overview. The same symbolic family produces Lorentzian, Galilean, and Euclidean regimes depending only on the sign of kappa."
  ],
  Cell[CellGroupData[{
    outputCell @ regimeGraphic[1/2],
    codeCell @ Manipulate[
      regimeGraphic[k],
      {{k, 1/2, "kappa"}, {-1, -1/2, 0, 1/2, 1}},
      ControlType -> SetterBar,
      SaveDefinitions -> True
    ]
  }, Open]],

  makeSectionCell["The transformation law and the Galilean limit"],
  makeTextCell["These are the same formulas stated in the paper: gamma controls the boost family, time-space mixing is scaled by kappa, and the Galilean case appears as the exact kappa -> 0 limit."],
  codeResultGroup[gammaExpr[kappa]],
  codeResultGroup[tPrimeExpr[kappa]],
  codeResultGroup[xPrimeExpr[kappa]],
  codeResultGroup[Simplify[Limit[gammaExpr[kappa], kappa -> 0]]],
  codeResultGroup[Simplify[Limit[{tPrimeExpr[kappa], xPrimeExpr[kappa]}, kappa -> 0]]],

  makeSectionCell["The kinematic bracket family"],
  makeTextCell["The bracket table below matches the local Lean conventions: rotations close among themselves, rotations send boosts to boosts, and the boost commutator scales as -kappa times a rotation."],
  outputCell @ Grid[
    {
      {"Bracket", "Exact local formula"},
      {"[J_i, J_j]", "Sum_k epsilon_ijk J_k"},
      {"[J_i, K_j]", "Sum_k epsilon_ijk K_k"},
      {"[K_i, K_j]", "Sum_k (-(kappa) epsilon_ijk) J_k"}
    },
    Background -> {None, {colors["SoftSlate"], White, White, White}},
    Dividers -> All,
    Alignment -> Left,
    ItemStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
    Spacings -> {1.0, 0.9}
  ],
  codeResultGroup[DiagonalMatrix[{-kappa, -kappa, -kappa}]],
  makeTextCell["That boost block scaling is the local computational shadow of `boostCommutator_scales_with_kappa` in `OnePostulate/KinematicAlgebra.lean`."],

  makeSectionCell["Computing the Killing form"],
  makeTextCell["The decisive invariant is computed before any geometry is interpreted. In the local Lean development this is `killing_form_diag` and `boost_killing_form_eq`."],
  outputCell @ withCaption[
    killingGraphic,
    "Killing-form preview. The rotation block never vanishes; the boost block is exactly where kappa enters."
  ],
  codeResultGroup[killingFormMatrixExpr[kappa]],
  codeResultGroup[Factor[Det[killingFormMatrixExpr[kappa]]]],
  codeResultGroup[Eigenvalues[killingFormMatrixExpr[kappa]]],

  makeSectionCell["Why the Killing form decides the geometry"],
  makeTextCell["Once the Killing form is diagonalized, the sign and degeneracy of the boost block become a structural test. At kappa = 0 the form goes blind on boosts; away from zero it sees them."],
  Cell[CellGroupData[{
    outputCell @ killingInteractivePanel[0],
    codeCell @ Manipulate[
      killingInteractivePanel[k],
      {{k, 0, "kappa"}, {-1, -1/2, 0, 1/2, 1}},
      ControlType -> SetterBar,
      SaveDefinitions -> True
    ]
  }, Open]],
  codeResultGroup[boostBlockExpr[kappa]],
  codeResultGroup[Simplify[Det[boostBlockExpr[kappa]]]],

  makeSectionCell["Velocity-space and spacetime consequences"],
  makeTextCell["The same kappa that scales the boost block fixes the velocity metric and the spacetime metric. Positive kappa gives a real invariant speed; zero kappa loses the canonical scale; negative kappa removes Lorentzian causal structure."],
  outputCell @ withCaption[
    spacetimeGraphic,
    "Spacetime consequence preview. The invariant form is `diag(1,-kappa,-kappa,-kappa)`, with distinct geometric readings in the three regimes."
  ],
  codeResultGroup[velocityMetricExpr[kappa]],
  codeResultGroup[invariantSpeedSquaredExpr[kappa]],
  codeResultGroup[spacetimeMetricExpr[kappa]],
  codeResultGroup[
    Simplify[
      Transpose[lorentzCongruenceExpr[kappa]].spacetimeMetricExpr[kappa].lorentzCongruenceExpr[kappa],
      kappa > 0
    ]
  ],
  Cell[CellGroupData[{
    outputCell @ spacetimeInteractivePanel[1/2],
    codeCell @ Manipulate[
      spacetimeInteractivePanel[k],
      {{k, 1/2, "kappa"}, {-1, -1/2, 0, 1/2, 1}},
      ControlType -> SetterBar,
      SaveDefinitions -> True
    ]
  }, Open]],

  makeSectionCell["Three branches, three verdicts"],
  makeTextCell["The notebook keeps the interpretation compact: Euclidean when kappa is negative, Galilean when the boost block vanishes, Lorentzian when kappa is positive and spacetime is congruent to the standard Lorentz metric."],
  outputCell[branchComparisonGrid],

  makeSectionCell["How this connects to the Lean proof"],
  makeTextCell["The crosswalk is intentionally concise. Wolfram computes exact expressions and visuals; Lean remains the proof authority for bracket identities, invariant forms, and branch-selection statements."],
  outputCell @ withCaption[
    crosswalkGraphic,
    "Crosswalk graphic. Each narrative stage names what is computed or visualized here and the corresponding Lean anchors that formalize it."
  ],
  outputCell[crosswalkGrid],

  makeSectionCell["What is computed here vs proved in Lean"],
  makeSubsectionCell["Computed or visualized here"],
  makeTextCell["Exact limits of the transformation law, the diagonal Killing form, determinant and eigenvalue checks, the invariant speed formula 1/kappa, the spacetime metric, and the Lorentz congruence calculation for positive kappa."],
  makeSubsectionCell["Formally proved in Lean"],
  makeTextCell["`matrix_bracket_JJ`, `matrix_bracket_JK`, `matrix_bracket_KK`, `kinematic_bracket_table`, `kinematic_bracket_jacobi`, `boostCommutator_scales_with_kappa`, `killing_form_diag`, `boost_killing_form_eq`, `boost_killing_nondegenerate_iff_kappa_ne_zero`, `killing_restricts_to_metric`, `zero_kappa_velocity_metric_only_conformal`, `invariantSpeedSquared_formula`, `spacetime_metric_eq_diagonal`, `spacetime_metric_invariant`, `reducible_of_kappa_zero`, `spacetime_metric_congruent_stdLorentz_of_kappa_pos`, `positive_kappa_selects_lorentz`, `zero_kappa_selects_galilean`, `negative_kappa_selects_euclidean`, `negative_kappa_no_nonzero_null_vectors`, `positive_kappa_gives_finite_real_invariant_speed`, `phase1_selection_summary`, and the supplemental `classification_derivation_complete` / `classification_derivation_complete_full`."],
  makeSubsectionCell["Interpretive narrative from the paper"],
  makeTextCell["The public-facing claims about causality, absolute time, and why the Killing form is read before geometry are narrative summaries from `paper/one-postulate.tex`. They are separated from the exact Wolfram computations and the formal Lean theorems on purpose."]
};

nb = Notebook[
  notebookCells,
  StyleDefinitions -> "Default.nb",
  WindowTitle -> "One Postulate in Wolfram",
  TaggingRules -> <|"Repository" -> "one-postulate-lean", "Generator" -> "wolfram/build_one_postulate_notebook.wl"|>
];

notebookPath = FileNameJoin[{notebooksDir, "one_postulate_explainer.nb"}];

Export[notebookPath, nb, "NB"];
Export[FileNameJoin[{assetsDir, "notebook_hero_overview.svg"}], heroGraphic];
Export[FileNameJoin[{assetsDir, "notebook_preview_branches.svg"}], kappaBranchGraphic];
Export[FileNameJoin[{assetsDir, "notebook_preview_killing_form.svg"}], killingGraphic];
Export[FileNameJoin[{assetsDir, "notebook_preview_spacetime.svg"}], spacetimeGraphic];
Export[FileNameJoin[{assetsDir, "notebook_preview_crosswalk.svg"}], crosswalkGraphic];

Print["Wrote ", notebookPath];
Print["Wrote SVG assets to ", assetsDir];
