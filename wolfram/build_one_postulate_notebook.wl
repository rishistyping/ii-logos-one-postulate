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

svgPostprocessor = FileNameJoin[{wolframDir, "flatten_svg_uses.py"}];

pythonExecutable[] := Module[
  {candidate = Quiet @ Check[FindExecutable["python3"], $Failed]},
  Which[
    StringQ[candidate] && candidate =!= "", candidate,
    FileExistsQ["/opt/homebrew/Caskroom/miniconda/base/bin/python3"], "/opt/homebrew/Caskroom/miniconda/base/bin/python3",
    FileExistsQ["/usr/bin/python3"], "/usr/bin/python3",
    True, $Failed
  ]
];

postprocessSvg[path_String] := Module[
  {python = pythonExecutable[], result},
  If[! StringQ[python] || ! FileExistsQ[svgPostprocessor],
    Return[path]
  ];
  result = RunProcess[{python, svgPostprocessor, path}];
  If[result["ExitCode"] =!= 0,
    Print["SVG postprocess failed for ", path, ": ", StringTrim[result["StandardError"]]]
  ];
  path
];

exportSvgAsset[name_String, expr_] := Module[
  {path = FileNameJoin[{assetsDir, name}]},
  Export[path, expr, "SVG"];
  postprocessSvg[path]
];

ClearAll[kappa, v, t, x, s];
$Assumptions = Element[{v, t, x, s}, Reals];

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

titleStyle = Directive[colors["Text"], FontFamily -> "Georgia", FontSize -> 26, Bold];
sectionStyle = Directive[colors["Text"], FontFamily -> "Georgia", FontSize -> 22, Bold];
cardTitleStyle[color_] := Directive[color, FontFamily -> "Georgia", FontSize -> 18, Bold];
previewTitleStyle = Directive[colors["Text"], FontFamily -> "Georgia", FontSize -> 24, Bold];
previewCardTitleStyle[color_] := Directive[color, FontFamily -> "Georgia", FontSize -> 16, Bold];
bodyStyle = Directive[colors["Text"], FontFamily -> "Helvetica", FontSize -> 13];
smallBodyStyle = Directive[colors["Text"], FontFamily -> "Helvetica", FontSize -> 11];
captionStyle = Directive[colors["Slate"], FontFamily -> "Helvetica", FontSize -> 11];
previewBodyStyle = Directive[colors["Text"], FontFamily -> "Helvetica", FontSize -> 12];
previewCaptionStyle = Directive[colors["Slate"], FontFamily -> "Helvetica", FontSize -> 12];

makeTextCell[text_] := Cell[text, "Text"];
makeSectionCell[text_] := Cell[text, "Section"];
makeSubsectionCell[text_] := Cell[text, "Subsection"];

questionCell[text_] := Cell[
  TextData[{StyleBox["Question. ", FontWeight -> "Bold", FontColor -> RGBColor["#2457A6"]], text}],
  "Text"
];

answerCell[text_] := Cell[
  TextData[{StyleBox["Answer. ", FontWeight -> "Bold", FontColor -> RGBColor["#2E7D6D"]], text}],
  "Text"
];

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
lorentzCongruenceExpr[k_] := DiagonalMatrix[{1, 1/Sqrt[k], 1/Sqrt[k], 1/Sqrt[k]}];
invariantSpeedSquaredExpr[k_] := 1/k;

branchName[k_?NumericQ] := Which[
  Chop[k] < 0, "Euclidean branch",
  Chop[k] == 0, "Galilean branch",
  True, "Lorentzian branch"
];

branchColor[k_?NumericQ] := Which[
  Chop[k] < 0, colors["Euclidean"],
  Chop[k] == 0, colors["Galilean"],
  True, colors["Lorentz"]
];

branchFill[k_?NumericQ] := Which[
  Chop[k] < 0, colors["SoftEuclidean"],
  Chop[k] == 0, colors["SoftGalilean"],
  True, colors["SoftLorentz"]
];

branchSummary[k_?NumericQ] := Which[
  Chop[k] < 0, "Boosts behave like rotations and no causal cone appears.",
  Chop[k] == 0, "Boosts commute, the ruler disappears, and absolute time survives.",
  True, "A finite invariant speed appears and spacetime becomes Lorentzian."
];

clipEvent[pt_List] := {
  Clip[pt[[1]], {-2.5, 2.5}],
  Clip[pt[[2]], {-2.5, 2.5}]
};

formatNumber[val_?NumericQ] := ToString @ NumberForm[N[val], {5, 3}];
formatPoint[pt_List] := "(" <> formatNumber[pt[[1]]] <> ", " <> formatNumber[pt[[2]]] <> ")";

criticalSpeed[k_?NumericQ] := If[Chop[k] > 0, 1/Sqrt[k], Infinity];

validTransformationQ[k_?NumericQ, vel_?NumericQ] := Chop[k] <= 0 || 1 - k vel^2 > 0;

safeGammaNumeric[k_?NumericQ, vel_?NumericQ] := Module[
  {radicand = 1 - k vel^2},
  If[Chop[k] > 0 && radicand <= 0, Indeterminate, N[1/Sqrt[radicand]]]
];

primePoint[k_?NumericQ, vel_?NumericQ, pt_List] := Module[
  {g = safeGammaNumeric[k, vel]},
  If[! NumericQ[g],
    {Indeterminate, Indeterminate},
    {
      g (pt[[1]] - vel pt[[2]]),
      g (pt[[2]] - k vel pt[[1]])
    }
  ]
];

speedMessage[k_?NumericQ, vel_?NumericQ] := Which[
  Chop[k] > 0 && ! validTransformationQ[k, vel],
    "The selected speed is at or beyond the finite invariant speed 1/Sqrt[kappa].",
  Chop[k] > 0 && Abs[vel] > 0.9 criticalSpeed[k],
    "gamma is growing quickly as |v| approaches 1/Sqrt[kappa].",
  Chop[k] == 0,
    "At kappa = 0 the mixing vanishes: t' = t and the Galilean law is recovered.",
  Chop[k] < 0,
    "Negative kappa keeps the formulas real but removes Lorentzian causal structure.",
  True,
    "Positive kappa mixes space into time and produces a finite invariant speed."
];

badge[label_, fill_, textColor_] := Framed[
  Style[label, FontFamily -> "Helvetica", FontSize -> 10, Bold, textColor],
  Background -> fill,
  FrameStyle -> Directive[fill, AbsoluteThickness[1.5]],
  RoundingRadius -> 10,
  FrameMargins -> {{8, 8}, {4, 4}}
];

authorityStrip[anchor_] := Row[
  {
    badge["Computed here", colors["SoftLorentz"], colors["Lorentz"]],
    badge["Paper narrative", colors["SoftEuclidean"], colors["Euclidean"]],
    badge["Lean: " <> anchor, colors["SoftGalilean"], colors["Galilean"]]
  },
  Spacer[7]
];

badgedPanel[title_, anchor_, content_, caption_] := Framed[
  Column[
    {
      authorityStrip[anchor],
      Style[title, sectionStyle],
      content,
      Style[caption, captionStyle]
    },
    Spacings -> 0.8
  ],
  Background -> colors["Card"],
  FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[1.8]],
  RoundingRadius -> 12,
  FrameMargins -> {{16, 16}, {14, 14}},
  ImageSize -> 1100
];

axesElements[] := {
  Directive[colors["Slate"], AbsoluteThickness[1.5]],
  Arrow[{{-2.8, 0}, {2.8, 0}}],
  Arrow[{{0, -2.8}, {0, 2.8}}],
  Inset[Style["x", smallBodyStyle], {2.95, -0.18}],
  Inset[Style["t", smallBodyStyle], {0.18, 2.92}]
};

lorentzUniverseGraphic[k_?NumericQ] := Show[
  RegionPlot[
    tt^2 >= k xx^2,
    {xx, -2.7, 2.7},
    {tt, -2.7, 2.7},
    PlotStyle -> Directive[Opacity[0.45], colors["SoftLorentz"]],
    BoundaryStyle -> None,
    Axes -> False,
    Frame -> False,
    PlotPoints -> 40,
    PerformanceGoal -> "Quality"
  ],
  ContourPlot[
    tt^2 - k xx^2,
    {xx, -2.7, 2.7},
    {tt, -2.7, 2.7},
    Contours -> {0},
    ContourStyle -> Directive[colors["Lorentz"], AbsoluteThickness[3]],
    ContourShading -> False,
    Axes -> False,
    Frame -> False,
    PlotPoints -> 40,
    PerformanceGoal -> "Quality"
  ],
  Graphics[
    {
      axesElements[],
      Inset[
        Style["lightcones and finite propagation speed", smallBodyStyle],
        {0, -3.05}
      ]
    }
  ],
  PlotRange -> {{-3, 3}, {-3.2, 3.05}},
  Background -> branchFill[k],
  ImageSize -> 390
];

galileanUniverseGraphic[] := Graphics[
  {
    axesElements[],
    {Directive[colors["Galilean"], AbsoluteThickness[2.2], Dashing[{0.03, 0.02}]],
      Table[Line[{{-2.6, y}, {2.6, y}}], {y, -2.2, 2.2, 0.55}]},
    Inset[
      Style["horizontal slices of simultaneity fill the frame", smallBodyStyle],
      {0, -3.05}
    ]
  },
  PlotRange -> {{-3, 3}, {-3.2, 3.05}},
  Background -> branchFill[0.],
  ImageSize -> 390
];

euclideanUniverseGraphic[] := Show[
  ContourPlot[
    xx^2 + tt^2,
    {xx, -2.7, 2.7},
    {tt, -2.7, 2.7},
    Contours -> {3.2},
    ContourStyle -> Directive[colors["Euclidean"], AbsoluteThickness[3]],
    ContourShading -> False,
    Axes -> False,
    Frame -> False,
    PlotPoints -> 40,
    PerformanceGoal -> "Quality"
  ],
  Graphics[
    {
      axesElements[],
      {Directive[colors["Euclidean"], AbsoluteThickness[3], Arrowheads[0.035]],
        Arrow[BezierCurve[{{0.35, 1.7}, {1.7, 1.2}, {1.5, -0.35}}]],
        Arrow[BezierCurve[{{-0.35, -1.7}, {-1.7, -1.2}, {-1.5, 0.35}}]]},
      Inset[
        Style["boosts cycle like rotations and no causal cone appears", smallBodyStyle],
        {0, -3.05}
      ]
    }
  ],
  PlotRange -> {{-3, 3}, {-3.2, 3.05}},
  Background -> branchFill[-0.6],
  ImageSize -> 390
];

universeBackgroundGraphic[k_?NumericQ] := Which[
  Chop[k] > 0, lorentzUniverseGraphic[k],
  Chop[k] == 0, galileanUniverseGraphic[],
  True, euclideanUniverseGraphic[]
];

transformationGraphic[k_?NumericQ, vel_?NumericQ, pt_List] := Module[
  {prime = primePoint[k, vel, pt]},
  Show[
    universeBackgroundGraphic[k],
    Graphics[
      {
        {Directive[colors["Text"], PointSize[0.022]], Point[pt]},
        Inset[Style["(x, t)", smallBodyStyle], pt + {0.42, 0.22}],
        If[ListQ[prime] && FreeQ[prime, Indeterminate],
          {
            Directive[branchColor[k], AbsoluteThickness[2.2], Arrowheads[0.03]],
            Arrow[{pt, prime}],
            PointSize[0.022],
            Point[prime],
            Inset[Style["(x', t')", smallBodyStyle], prime + {0.52, -0.24}]
          },
          {
            Inset[
              Framed[
                Style["transformation undefined here", smallBodyStyle],
                Background -> colors["Card"],
                FrameStyle -> branchColor[k],
                RoundingRadius -> 8,
                FrameMargins -> {{8, 8}, {4, 4}}
              ],
              {0, 2.55}
            ]
          }
        ]
      }
    ],
    PlotRange -> {{-3, 3}, {-3.2, 3.05}},
    ImageSize -> 430
  ]
];

transformationSummaryPanel[k_?NumericQ, vel_?NumericQ, pt_List] := Module[
  {
    g = safeGammaNumeric[k, vel],
    prime = primePoint[k, vel, pt],
    speed = criticalSpeed[k]
  },
  Framed[
    Column[
      {
        Style[branchName[k], cardTitleStyle[branchColor[k]]],
        Grid[
          {
            {"kappa", formatNumber[k]},
            {"v", formatNumber[vel]},
            {"gamma", If[NumericQ[g], formatNumber[g], "undefined"]},
            {"(x, t)", formatPoint[pt]},
            {"(x', t')",
              If[ListQ[prime] && FreeQ[prime, Indeterminate], formatPoint[prime], "not defined at this speed"]},
            {"critical speed",
              If[Chop[k] > 0, "1/Sqrt[kappa] = " <> formatNumber[speed], "none / not real"]}
          },
          Alignment -> Left,
          Dividers -> {None, {False, True, True, True, True, True, False}},
          ItemStyle -> {
            Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
            Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]]
          },
          Spacings -> {1.1, 0.85}
        ],
        Style[speedMessage[k, vel], bodyStyle],
        Style[branchSummary[k], captionStyle]
      },
      Spacings -> 0.7
    ],
    Background -> branchFill[k],
    FrameStyle -> Directive[branchColor[k], AbsoluteThickness[1.8]],
    RoundingRadius -> 12,
    FrameMargins -> {{14, 14}, {12, 12}},
    ImageSize -> {340, Automatic}
  ]
];

transformationTab[k_Symbol, vel_Symbol, event_Symbol] := Grid[
  {{
    LocatorPane[
      Dynamic[event, (event = clipEvent[#]) &],
      Dynamic[transformationGraphic[k, vel, event], TrackedSymbols :> {k, vel, event}],
      Appearance -> None
    ],
    Dynamic[transformationSummaryPanel[k, vel, event], TrackedSymbols :> {k, vel, event}]
  }},
  Alignment -> {Left, Top},
  Spacings -> {1.25, 0.8}
];

killingMatrixPlot[k_?NumericQ, size_:310] := MatrixPlot[
  N[killingFormMatrixExpr[k]],
  ColorFunction -> (Blend[{colors["Euclidean"], White, colors["Lorentz"]}, Rescale[#, {-4, 4}]] &),
  ColorFunctionScaling -> False,
  Mesh -> All,
  PlotRange -> {-4, 4},
  FrameTicks -> {
    Thread[{Range[6], {"J1", "J2", "J3", "K1", "K2", "K3"}}],
    Thread[{Range[6], {"J1", "J2", "J3", "K1", "K2", "K3"}}]
  },
  LabelStyle -> smallBodyStyle,
  Background -> colors["Card"],
  ImagePadding -> {{42, 18}, {18, 30}},
  ImageSize -> size
];

killingEigenPlot[k_?NumericQ, size_:360] := Show[
  Plot[
    {-4, 4 s},
    {s, -1, 1},
    PlotStyle -> {
      Directive[colors["Slate"], AbsoluteThickness[2.5]],
      Directive[branchColor[k], AbsoluteThickness[2.5]]
    },
    Frame -> True,
    FrameLabel -> {"kappa", "eigenvalue"},
    GridLines -> {{0, k}, {0}},
    GridLinesStyle -> Directive[Opacity[0.25], colors["Slate"]],
    LabelStyle -> smallBodyStyle,
    PlotRange -> {{-1, 1}, {-4.6, 4.6}},
    ImagePadding -> {{52, 18}, {32, 12}},
    ImageSize -> size
  ],
  Graphics[
    {
      {colors["Slate"], PointSize[0.022], Point[{k, -4}]},
      {branchColor[k], PointSize[0.022], Point[{k, 4 k}]},
      Inset[Style["rotation x3", smallBodyStyle], {-0.72, -3.2}],
      Inset[Style["boost x3", smallBodyStyle], {0.62, 2.75}]
    }
  ],
  ImagePadding -> {{52, 18}, {32, 12}},
  ImageSize -> size
];

killingStatus[k_?NumericQ] := Which[
  Chop[k] == 0, "The boost sector is exactly invisible: the algebra goes blind on boosts.",
  Chop[k] > 0, "The boost eigenvalues are positive, so the boost block is visible and Lorentzian data can be read off.",
  True, "The boost eigenvalues are negative, so the whole algebra is compact and causal structure does not emerge."
];

killingFormPanel[k_?NumericQ] := Framed[
  Column[
    {
      Style["Killing form self-test", cardTitleStyle[branchColor[k]]],
      Grid[
        {
          {killingMatrixPlot[k], killingEigenPlot[k]},
          {
            Grid[
              {
                {"Boost block", MatrixForm[boostBlockExpr[k]]},
                {"det(B)", TraditionalForm[Factor[Det[killingFormMatrixExpr[k]]]]},
                {"Eigenvalues", TraditionalForm[Eigenvalues[killingFormMatrixExpr[k]]]},
                {"Readout", killingStatus[k]}
              },
              Alignment -> Left,
              Dividers -> {None, {False, True, True, True, False}},
              ItemStyle -> {
                Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
                Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]]
              },
              Spacings -> {1.0, 0.8}
            ],
            SpanFromLeft
          }
        },
        Alignment -> Left,
        Spacings -> {1.1, 0.9}
      ]
    },
    Spacings -> 0.8
  ],
  Background -> branchFill[k],
  FrameStyle -> Directive[branchColor[k], AbsoluteThickness[1.8]],
  RoundingRadius -> 12,
  FrameMargins -> {{14, 14}, {12, 12}},
  ImageSize -> 1080
];

previewInfoCard[title_, lines_, color_] := Framed[
  Column[
    {
      Style[title, previewCardTitleStyle[color]],
      lines
    },
    Spacings -> 0.45
  ],
  Background -> colors["Card"],
  FrameStyle -> Directive[color, AbsoluteThickness[1.6]],
  RoundingRadius -> 12,
  FrameMargins -> {{14, 14}, {12, 12}},
  ImageSize -> {336, Automatic}
];

killingPreviewGraphic = Framed[
  Column[
    {
      Column[
        {
          Style["Killing form self-test", previewTitleStyle],
          Style[
            "At positive kappa, the rotation block stays fixed while the boost block remains visible. That is the algebraic pivot that selects the Lorentzian branch.",
            previewCaptionStyle
          ]
        },
        Spacings -> 0.3
      ],
      Grid[
        {{
          Framed[
            Column[
              {
                Style["Matrix view", previewCardTitleStyle[colors["Text"]]],
                killingMatrixPlot[0.6, 400],
                Style["B = diag(-4 I3, 4 kappa I3)", captionStyle]
              },
              Spacings -> 0.55
            ],
            Background -> colors["Card"],
            FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[1.6]],
            RoundingRadius -> 12,
            FrameMargins -> {{14, 14}, {12, 12}},
            ImageSize -> {520, Automatic}
          ],
          Framed[
            Column[
              {
                Style["Eigenvalue split", previewCardTitleStyle[colors["Lorentz"]]],
                killingEigenPlot[0.6, 440],
                Style["The boost track crosses zero at kappa = 0; the rotation track never does.", captionStyle]
              },
              Spacings -> 0.55
            ],
            Background -> colors["Card"],
            FrameStyle -> Directive[colors["Lorentz"], AbsoluteThickness[1.6]],
            RoundingRadius -> 12,
            FrameMargins -> {{14, 14}, {12, 12}},
            ImageSize -> {560, Automatic}
          ]
        }},
        Alignment -> {Left, Top},
        Spacings -> {1.0, 0.8}
      ],
      Grid[
        {{
          previewInfoCard[
            "Boost block",
            Column[
              {
                Style["Boost block = 4 kappa I3", previewBodyStyle],
                Style["At kappa = 0.6 this becomes 2.4 I3.", previewCaptionStyle]
              },
              Spacings -> 0.32
            ],
            colors["Lorentz"]
          ],
          previewInfoCard[
            "Determinant and split",
            Column[
              {
                Style["det(B) = (-4)^3 (4 kappa)^3", previewBodyStyle],
                Style["rotation: -4 x3; boost: 4 kappa x3", previewCaptionStyle]
              },
              Spacings -> 0.32
            ],
            colors["Slate"]
          ],
          previewInfoCard[
            "Interpretive verdict",
            Column[
              {
                Style["At kappa > 0, the boost sector is visible.", previewBodyStyle],
                Style["That is why the Lorentzian branch survives.", previewCaptionStyle]
              },
              Spacings -> 0.32
            ],
            colors["Galilean"]
          ]
        }},
        Alignment -> {Left, Top},
        Spacings -> {0.9, 0.8}
      ]
    },
    Spacings -> 0.95
  ],
  Background -> colors["Background"],
  FrameStyle -> Directive[colors["Lorentz"], AbsoluteThickness[2.0]],
  RoundingRadius -> 14,
  FrameMargins -> {{20, 20}, {18, 18}},
  ImageSize -> {1180, 640}
];

velocitySpaceGraphic[k_?NumericQ, vel_?NumericQ] := Module[
  {
    r = If[Chop[k] > 0, criticalSpeed[k], Infinity],
    displayRadius,
    marker = Min[Abs[vel], 2.05]
  },
  displayRadius = If[NumericQ[r], Min[r, 2.1], 2.1];
  Graphics[
    {
      axesElements[],
      Which[
        Chop[k] > 0 && NumericQ[r] && r <= 2.1,
          {
            Directive[colors["Lorentz"], AbsoluteThickness[3]],
            Circle[{0, 0}, r],
            Arrow[{{0, 0}, {r, 0}}],
            Inset[Style["V = 1/Sqrt[kappa]", bodyStyle], {0.9, 0.38}]
          },
        Chop[k] > 0 && NumericQ[r],
          {
            Directive[colors["Lorentz"], AbsoluteThickness[2.5], Dashing[{0.025, 0.02}]],
            Circle[{0, 0}, 2.1],
            Inset[Style["preferred radius lies beyond the frame", bodyStyle], {0, 2.5}]
          },
        Chop[k] == 0,
          {
            Directive[colors["Galilean"], AbsoluteThickness[1.6], Opacity[0.45]],
            Table[Circle[{0, 0}, rr], {rr, 0.55, 2.1, 0.38}],
            Inset[Style["shape fixed, scale lost", bodyStyle], {0, 2.5}],
            Inset[Style["?", FontFamily -> "Georgia", FontSize -> 32, colors["Galilean"]], {1.25, 1.25}]
          },
        True,
          {
            Directive[colors["Euclidean"], AbsoluteThickness[2.5], Dashing[{0.025, 0.02}]],
            Circle[{0, 0}, 1.55],
            Inset[Style["V is not real here", bodyStyle], {0, 2.5}]
          }
      ],
      {Directive[colors["Text"], PointSize[0.02]], Point[{marker, 0}]},
      Inset[Style["current |v|", smallBodyStyle], {marker, -0.28}]
    },
    PlotRange -> {{-3, 3}, {-3.2, 3.05}},
    Background -> branchFill[k],
    ImageSize -> 420
  ]
];

velocitySummaryPanel[k_?NumericQ] := Framed[
  Column[
    {
      Style["Velocity-space ruler", cardTitleStyle[branchColor[k]]],
      Grid[
        {
          {"B(K_i, K_j)", "4 kappa delta_ij"},
          {"V^2", Which[Chop[k] == 0, "undefined", True, TraditionalForm[invariantSpeedSquaredExpr[k]]]},
          {"Interpretation",
            Which[
              Chop[k] > 0, "The Killing form fixes a preferred radius and therefore a finite invariant speed.",
              Chop[k] == 0, "Rotational symmetry fixes the shape, but the algebra cannot choose a ruler.",
              True, "The formal speed scale is not real, so no physical invariant speed appears."
            ]}
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
    Spacings -> 0.7
  ],
  Background -> branchFill[k],
  FrameStyle -> Directive[branchColor[k], AbsoluteThickness[1.8]],
  RoundingRadius -> 12,
  FrameMargins -> {{14, 14}, {12, 12}},
  ImageSize -> {620, Automatic}
];

velocitySpacePanel[k_?NumericQ, vel_?NumericQ] := Grid[
  {{
    velocitySpaceGraphic[k, vel],
    velocitySummaryPanel[k]
  }},
  Alignment -> {Left, Top},
  Spacings -> {1.2, 0.8}
];

verdictGridData = {
  {"Verdict", "kappa < 0", "kappa = 0", "kappa > 0"},
  {"Killing form on boosts", "4 kappa < 0", "0", "4 kappa > 0"},
  {"Invariant speed", "imaginary", "undefined", "finite and real"},
  {"Spacetime metric", "Euclidean", "dt^2 only", "Lorentzian"},
  {"Causal structure", "none", "none", "lightcones"},
  {"Space-time unification", "all directions alike", "impossible", "complete"},
  {"Background structure needed", "none", "yes", "none"}
};

verdictBackgroundMatrix[k_?NumericQ] := Module[
  {selected = Which[Chop[k] < 0, 2, Chop[k] == 0, 3, True, 4]},
  Table[
    Which[
      row == 1 && col == 1, colors["SoftSlate"],
      row == 1 && col == 2, If[selected == 2, Lighter[colors["Euclidean"], 0.75], colors["SoftEuclidean"]],
      row == 1 && col == 3, If[selected == 3, Lighter[colors["Galilean"], 0.75], colors["SoftGalilean"]],
      row == 1 && col == 4, If[selected == 4, Lighter[colors["Lorentz"], 0.75], colors["SoftLorentz"]],
      col == 1, colors["SoftSlate"],
      col == 2, colors["SoftEuclidean"],
      col == 3, colors["SoftGalilean"],
      True, colors["SoftLorentz"]
    ],
    {row, Length[verdictGridData]},
    {col, Length[First[verdictGridData]]}
  ]
];

verdictPanel[k_?NumericQ] := Framed[
  Column[
    {
      Style["Three branches, three verdicts", cardTitleStyle[branchColor[k]]],
      Style["Only the positive-kappa branch yields a finite real invariant speed, a Lorentzian metric, and causal structure without importing background geometry.", bodyStyle],
      Grid[
        verdictGridData,
        Background -> verdictBackgroundMatrix[k],
        Dividers -> All,
        Alignment -> Left,
        ItemStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 12, colors["Text"]],
        ItemSize -> {{22, 14, 14, 16}, Automatic},
        Spacings -> {1.0, 0.9}
      ],
      Style["Calibration note: experiment fixes the numerical value of the invariant speed once the algebra has already selected the positive-kappa branch.", captionStyle]
    },
    Spacings -> 0.8
  ],
  Background -> colors["Card"],
  FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[1.8]],
  RoundingRadius -> 12,
  FrameMargins -> {{14, 14}, {12, 12}},
  ImageSize -> 1080
];

controlPanel[k_Symbol, vel_Symbol, event_Symbol, tab_Symbol] := Framed[
  Column[
    {
      Style["Explore the argument live", cardTitleStyle[colors["Text"]]],
      Grid[
        {
          {
            Style["kappa", bodyStyle],
            Slider[Dynamic[k], {-1, 1}],
            Dynamic[Style[formatNumber[k], bodyStyle], TrackedSymbols :> {k}]
          },
          {
            Style["regime snap", bodyStyle],
            Row[
              {
                Button["kappa < 0", (k = -0.6; vel = 0.6; tab = "Transformation")],
                Button["kappa = 0", (k = 0.; vel = 0.8; tab = "Transformation")],
                Button["kappa > 0", (k = 0.6; vel = 0.55; tab = "Transformation")]
              },
              Spacer[8]
            ],
            SpanFromLeft
          },
          {
            Style["v", bodyStyle],
            Slider[Dynamic[vel], {-1.4, 1.4}],
            Dynamic[Style[formatNumber[vel], bodyStyle], TrackedSymbols :> {vel}]
          },
          {
            Style["event (x, t)", bodyStyle],
            Dynamic[Style[formatPoint[event], bodyStyle], TrackedSymbols :> {event}],
            SpanFromLeft
          }
        },
        Alignment -> Left,
        Spacings -> {1.2, 0.8},
        ItemSize -> {{12, 30, 14}, Automatic}
      ],
      Dynamic[
        Style[speedMessage[k, vel], If[validTransformationQ[k, vel], captionStyle, Directive[colors["Euclidean"], FontFamily -> "Helvetica", FontSize -> 11, Bold]]],
        TrackedSymbols :> {k, vel}
      ]
    },
    Spacings -> 0.8
  ],
  Background -> colors["Card"],
  FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[1.8]],
  RoundingRadius -> 12,
  FrameMargins -> {{14, 14}, {12, 12}},
  ImageSize -> 1080
];

explorationSuite[] := DynamicModule[
  {k = 0.6, vel = 0.55, event = {1.05, 1.45}, tab = "Transformation"},
  Column[
    {
      controlPanel[k, vel, event, tab],
      TabView[
        <|
          "Transformation" -> transformationTab[k, vel, event],
          "Killing form" -> Dynamic[killingFormPanel[k], TrackedSymbols :> {k}],
          "Velocity space" -> Dynamic[velocitySpacePanel[k, vel], TrackedSymbols :> {k, vel}],
          "Verdict" -> Dynamic[verdictPanel[k], TrackedSymbols :> {k}]
        |>,
        Dynamic[tab],
        ImageSize -> 1110
      ]
    },
    Spacings -> 1.0
  ]
];

heroOverviewGraphic = Graphics[
  {
    Inset[Style["One parameter, one self-test", titleStyle], {5.2, 5.3}],
    Inset[
      Framed[
        Column[
          {
            Style["The postulate", cardTitleStyle[colors["Text"]]],
            Style["No hidden background structure is allowed to do the conceptual work.", bodyStyle]
          },
          Spacings -> 0.45
        ],
        Background -> colors["Card"],
        FrameStyle -> colors["Slate"],
        RoundingRadius -> 12,
        FrameMargins -> {{12, 12}, {10, 10}}
      ],
      {1.7, 3.5}
    ],
    Inset[
      Framed[
        Column[
          {
            Style["What the postulate determines", cardTitleStyle[colors["Lorentz"]]],
            Style["t' = gamma (t - kappa v x)\nx' = gamma (x - v t)", bodyStyle],
            Style["kappa controls time-space mixing and the Galilean limit.", captionStyle]
          },
          Spacings -> 0.45
        ],
        Background -> colors["Card"],
        FrameStyle -> colors["Lorentz"],
        RoundingRadius -> 12,
        FrameMargins -> {{12, 12}, {10, 10}}
      ],
      {5.0, 3.5}
    ],
    Inset[
      Framed[
        Column[
          {
            Style["Can the rules examine themselves?", cardTitleStyle[colors["Galilean"]]],
            Style["B = diag(-4 I3, 4 kappa I3)", bodyStyle],
            Style["The boost block changes sign, vanishes at kappa = 0, and decides what geometry survives.", captionStyle]
          },
          Spacings -> 0.45
        ],
        Background -> colors["Card"],
        FrameStyle -> colors["Galilean"],
        RoundingRadius -> 12,
        FrameMargins -> {{12, 12}, {10, 10}}
      ],
      {8.3, 3.5}
    ],
    {Directive[colors["Slate"], AbsoluteThickness[2.2], Arrowheads[0.03]],
      Arrow[{{2.8, 3.5}, {3.55, 3.5}}],
      Arrow[{{6.05, 3.5}, {6.85, 3.5}}]},
    Inset[
      Framed[
        Column[
          {
            Style["Three verdicts", cardTitleStyle[colors["Euclidean"]]],
            Style["kappa < 0: no causal structure\nkappa = 0: the ruler is missing\nkappa > 0: finite invariant speed", bodyStyle]
          },
          Spacings -> 0.45
        ],
        Background -> colors["Card"],
        FrameStyle -> colors["Euclidean"],
        RoundingRadius -> 12,
        FrameMargins -> {{12, 12}, {10, 10}}
      ],
      {3.2, 1.1}
    ],
    Inset[
      Framed[
        Column[
          {
            Style["Structure and scale", cardTitleStyle[colors["Text"]]],
            Style["Experiment calibrates the numerical value of c.\nThe algebra already says that some finite invariant speed must exist.", bodyStyle]
          },
          Spacings -> 0.45
        ],
        Background -> colors["Card"],
        FrameStyle -> colors["Slate"],
        RoundingRadius -> 12,
        FrameMargins -> {{12, 12}, {10, 10}}
      ],
      {7.6, 1.1}
    ],
    {Directive[colors["Slate"], AbsoluteThickness[2.2], Arrowheads[0.03]],
      Arrow[{{5.25, 2.8}, {4.05, 1.75}}],
      Arrow[{{7.95, 2.8}, {7.95, 1.75}}]}
  },
  PlotRange -> {{0.3, 10.2}, {0.1, 5.8}},
  Background -> colors["Background"],
  ImageSize -> 1280
];

branchPreviewGraphic = Framed[
  Grid[
    {{
      Column[{Style["kappa < 0", cardTitleStyle[colors["Euclidean"]]], euclideanUniverseGraphic[]}, Spacings -> 0.45],
      Column[{Style["kappa = 0", cardTitleStyle[colors["Galilean"]]], galileanUniverseGraphic[]}, Spacings -> 0.45],
      Column[{Style["kappa > 0", cardTitleStyle[colors["Lorentz"]]], lorentzUniverseGraphic[0.6]}, Spacings -> 0.45]
    }},
    Spacings -> {1.0, 0.5}
  ],
  Background -> colors["Card"],
  FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[1.8]],
  RoundingRadius -> 12,
  FrameMargins -> {{14, 14}, {12, 12}},
  ImageSize -> 1220
];

spacetimePreviewGraphic = transformationGraphic[0.6, 0.55, {1.05, 1.45}];

crosswalkRows = {
  {
    "The postulate",
    "Hero overview and the no-background-structure framing",
    "OnePostulate/SpacetimeMatrices.lean; matrix_bracket_JJ; matrix_bracket_JK; matrix_bracket_KK",
    "paper framing plus Lean entry point"
  },
  {
    "What the postulate determines",
    "Transformation simulator, Galilean limit, and the Figure 1 regime view",
    "matrix_bracket_JJ; matrix_bracket_JK; matrix_bracket_KK; phase1_selection_summary",
    "paper plus Lean"
  },
  {
    "Can the rules examine themselves?",
    "Bracket table, Killing form, determinant, eigenvalues, and velocity-space ruler",
    "kinematic_bracket_table; boostCommutator_scales_with_kappa; killing_form_diag; boost_killing_nondegenerate_iff_kappa_ne_zero; killing_restricts_to_metric; invariantSpeedSquared_formula",
    "Lean with paper interpretation"
  },
  {
    "Three verdicts",
    "Verdict board, spacetime consequences, and regime comparison",
    "negative_kappa_no_nonzero_null_vectors; zero_kappa_selects_galilean; positive_kappa_selects_lorentz; positive_kappa_gives_finite_real_invariant_speed; spacetime_metric_invariant",
    "Lean plus paper verdict"
  },
  {
    "Structure and scale",
    "Calibration note and Lorentz congruence preview",
    "spacetime_metric_eq_diagonal; spacetime_metric_congruent_stdLorentz_of_kappa_pos; classification_derivation_complete_full",
    "paper plus Lean"
  }
};

crosswalkGraphic = Framed[
  Column[
    {
      Style["Paper, notebook, and Lean crosswalk", cardTitleStyle[colors["Text"]]],
      Grid[
        Prepend[crosswalkRows, {"Narrative stage", "Computed / visualized here", "Lean anchors", "Source of authority"}],
        Background -> {
          {colors["SoftSlate"], None, None, None, None, None},
          Join[
            {{colors["SoftSlate"]}},
            ConstantArray[{colors["SoftLorentz"], colors["SoftGalilean"], colors["SoftEuclidean"], colors["SoftSlate"]}, Length[crosswalkRows]]
          ]
        },
        Dividers -> All,
        Alignment -> Left,
        ItemStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 11, colors["Text"]],
        ItemSize -> {{15, 24, 34, 13}, Automatic},
        Spacings -> {1.0, 0.8}
      ]
    },
    Spacings -> 0.8
  ],
  Background -> colors["Card"],
  FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[1.8]],
  RoundingRadius -> 12,
  FrameMargins -> {{14, 14}, {12, 12}},
  ImageSize -> 1180
];

proofBoundaryGrid = Grid[
  {
    {"Category", "What belongs there"},
    {"Computed or visualized here",
      "Exact transformation-law limits, the shared dynamic panels, the Killing-form eigenvalue and determinant checks, the velocity-space ruler story, the verdict board, and the Lorentz congruence calculation for positive kappa."},
    {"Formally proved in Lean",
      "The local theorem anchors, bracket identities, invariant-form theorems, and branch-selection theorems exposed through OnePostulate.lean, OnePostulateFull.lean, and the modules under OnePostulate/."},
    {"Interpretive narrative from the paper",
      "Why the relativity principle forbids imported background structure, why kappa = 0 loses the ruler, why only kappa > 0 yields causal structure, and why experiment calibrates value rather than existence."}
  },
  Background -> {
    None,
    {
      colors["SoftSlate"],
      colors["SoftLorentz"],
      colors["SoftGalilean"],
      colors["SoftEuclidean"]
    }
  },
  Dividers -> All,
  Alignment -> Left,
  ItemStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 11, colors["Text"]],
  ItemSize -> {{18, 72}, Automatic},
  Spacings -> {1.0, 0.8}
];

notebookCells = {
  Cell["One Postulate in Wolfram", "Title"],
  makeTextCell["This notebook is a public-facing computational companion to the local paper and Lean development. It follows the paper's argument closely enough that a reader can feel why one branch survives, while still keeping Lean as the proof authority."],

  makeSectionCell["What this notebook is for"],
  questionCell["What is this notebook trying to make visible?"],
  makeTextCell["The goal is not to recreate every Lean proof step and not to turn the paper into a static summary card deck. The goal is to make the paper's dynamic claims visible: the kappa-dependent transformation law, the self-test supplied by the Killing form, the loss of a natural ruler at kappa = 0, and the emergence of finite invariant speed and Lorentzian causal structure only for kappa > 0."],
  makeTextCell["All mathematical and proof claims come from local repository files. Wolfram computes exact expressions and interactive views; the paper supplies the narrative; Lean supplies the proof authority."],
  answerCell["This notebook is a computational companion: exact where it should be, public-facing in its presentation, and explicit about what belongs to Wolfram, to the paper, and to Lean."],

  makeSectionCell["The postulate"],
  questionCell["What kind of explanation does the relativity principle allow?"],
  makeTextCell["Einstein's first postulate is treated here as a design principle: no hidden background structure should do the conceptual work that the symmetry rules themselves ought to do. The notebook therefore starts with the one-parameter family and delays geometric interpretation until the algebra has tested itself."],
  outputCell @ badgedPanel[
    "Hero overview",
    "matrix_bracket_JJ + matrix_bracket_JK + matrix_bracket_KK",
    heroOverviewGraphic,
    "The narrative arc matches the paper: one parameter controls the family, the Killing form performs the self-test, the three verdicts follow, and experiment calibrates value rather than existence."
  ],
  answerCell["The postulate allows only a self-contained explanation: external measurement may calibrate a scale later, but it should not choose the underlying geometric branch."],

  makeSectionCell["What the postulate determines"],
  questionCell["What changes when kappa changes sign or magnitude?"],
  makeTextCell["The transformation law already contains the full one-parameter family. The second equation shifts position by relative motion; the first mixes space into time with strength set by kappa. When kappa = 0, the mixing vanishes and Newtonian time returns. When kappa > 0, gamma diverges as |v| approaches 1/Sqrt[kappa]."],
  codeResultGroup[gammaExpr[kappa]],
  codeResultGroup[tPrimeExpr[kappa]],
  codeResultGroup[xPrimeExpr[kappa]],
  codeResultGroup[Simplify[Limit[gammaExpr[kappa], kappa -> 0]]],
  codeResultGroup[Simplify[Limit[{tPrimeExpr[kappa], xPrimeExpr[kappa]}, kappa -> 0]]],
  outputCell @ badgedPanel[
    "Shared exploration suite",
    "matrix_bracket_JJ + matrix_bracket_JK + matrix_bracket_KK + phase1_selection_summary",
    explorationSuite[],
    "Use the continuous kappa control, velocity slider, draggable event, and tabbed views to move between the three kinematic regimes without leaving the notebook."
  ],
  answerCell["One parameter controls the entire family: it changes the strength of time-space mixing, governs the Galilean limit, and determines whether a finite invariant speed can appear at all."],

  makeSectionCell["Can the rules examine themselves?"],
  questionCell["Can the algebra diagnose its own geometry without experiment?"],
  makeTextCell["Yes. The notebook follows the paper's answer: rotations and boosts are first treated as generators with a bracket structure, and the Killing form then computes the algebra's own diagnostic before any final spacetime metric is read off. The boost block is where the family distinguishes itself."],
  outputCell @ badgedPanel[
    "Bracket family",
    "kinematic_bracket_table + boostCommutator_scales_with_kappa",
    Grid[
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
    "The algebraic pivot is the boost commutator: when it collapses at kappa = 0, the later geometric failures all trace back to that loss of rigidity."
  ],
  codeResultGroup[killingFormMatrixExpr[kappa]],
  codeResultGroup[Factor[Det[killingFormMatrixExpr[kappa]]]],
  codeResultGroup[Eigenvalues[killingFormMatrixExpr[kappa]]],
  outputCell @ badgedPanel[
    "Killing form self-test",
    "killing_form_diag + boost_killing_form_eq + boost_killing_nondegenerate_iff_kappa_ne_zero",
    killingFormPanel[0.6],
    "The matrix view and eigenvalue plot make the paper's interpretive force visible: the rotation block stays fixed, the boost block changes sign, and the algebra becomes blind exactly at kappa = 0."
  ],
  answerCell["The algebra can examine itself. The Killing form is the decisive self-test, and it becomes blind precisely when the boost sector degenerates."],

  makeSectionCell["Three verdicts"],
  questionCell["What does the self-test say in each regime?"],
  makeTextCell["The notebook keeps the paper's verdict structure intact. Negative kappa leaves no causal distinction between directions. Zero kappa preserves shape but loses the ruler and leaves absolute time as background structure. Positive kappa yields the only branch with finite real invariant speed, Lorentzian metric, and causal structure."],
  codeResultGroup[invariantSpeedSquaredExpr[kappa]],
  codeResultGroup[spacetimeMetricExpr[kappa]],
  codeResultGroup[
    Simplify[
      Transpose[lorentzCongruenceExpr[kappa]].spacetimeMetricExpr[kappa].lorentzCongruenceExpr[kappa],
      kappa > 0
    ]
  ],
  outputCell @ badgedPanel[
    "Velocity-space ruler and verdict board",
    "killing_restricts_to_metric + invariantSpeedSquared_formula + spacetime_metric_invariant + phase1_selection_summary",
    Column[
      {
        velocitySpacePanel[0.6, 0.55],
        verdictPanel[0.6]
      },
      Spacings -> 1.0
    ],
    "The paper's Figure 2 logic and its final comparison table are kept together: the missing ruler at kappa = 0 is not a side note, it is part of why only the positive-kappa branch fully works."
  ],
  answerCell["Only kappa > 0 produces a finite real invariant speed, a Lorentzian spacetime metric, and causal structure without importing background geometry by hand."],

  makeSectionCell["Structure and scale"],
  questionCell["What still has to be calibrated by experiment?"],
  makeTextCell["The paper's final distinction is preserved here: once the algebra has selected the positive-kappa branch, experiment fixes the numerical value of the invariant speed rather than the existence of such a speed. In that sense, calibration is empirical but the structural verdict is not."],
  outputCell @ badgedPanel[
    "Calibration after selection",
    "spacetime_metric_eq_diagonal + spacetime_metric_congruent_stdLorentz_of_kappa_pos + positive_kappa_gives_finite_real_invariant_speed",
    Framed[
      Column[
        {
          Style["Structure first, value second", cardTitleStyle[colors["Text"]]],
          Style["If kappa > 0, then V = 1/Sqrt[kappa] is finite and real. Measuring c fixes the numerical value of kappa = 1/c^2; it does not choose whether the invariant-speed structure exists in the first place.", bodyStyle],
          Style["That is the notebook's closing claim because it is the paper's closing claim.", captionStyle]
        },
        Spacings -> 0.7
      ],
      Background -> colors["Card"],
      FrameStyle -> Directive[colors["Slate"], AbsoluteThickness[1.8]],
      RoundingRadius -> 12,
      FrameMargins -> {{14, 14}, {12, 12}},
      ImageSize -> 860
    ],
    "The value of the invariant speed is empirical calibration. The existence of a finite invariant speed is the algebra's conclusion."
  ],
  answerCell["Experiment calibrates the number. The algebra, if read through the Killing form, already determines that the surviving branch must carry a finite invariant speed."],

  makeSectionCell["How this connects to the Lean proof"],
  questionCell["Where does the formal proof live, and how does this notebook map onto it?"],
  makeTextCell["The crosswalk comes late on purpose. By the time it appears, the notebook should already have made the paper's geometric progression feel inevitable. Wolfram computes public-facing exact expressions and visuals; Lean formalizes the theorem statements and branch-selection results."],
  outputCell @ badgedPanel[
    "Paper -> notebook -> Lean crosswalk",
    "phase1_selection_summary + classification_derivation_complete + classification_derivation_complete_full",
    crosswalkGraphic,
    "The crosswalk is concise rather than exhaustive. Its job is to point a reader from the paper's rhetorical stages to the local formal surface without pretending the notebook is the proof."
  ],
  answerCell["The formal proof lives in the local Lean modules. The notebook computes, visualizes, and narrates the same architecture without widening the proof surface."],

  makeSectionCell["What is computed here vs proved in Lean"],
  questionCell["Which claims are computed here, and which are proved elsewhere?"],
  makeTextCell["The notebook keeps the proof boundary visible throughout with inline badges, but it closes with an explicit summary as well. This matters because the notebook is designed to persuade by making structure visible, not by silently upgrading itself into a proof assistant."],
  outputCell @ proofBoundaryGrid,
  answerCell["This notebook computes and visualizes exact expressions already present in the local development. Lean remains the proof authority, and the paper remains the source of the public-facing interpretive narrative."]
};

nb = Notebook[
  notebookCells,
  StyleDefinitions -> "Default.nb",
  WindowTitle -> "One Postulate in Wolfram",
  TaggingRules -> <|"Repository" -> "one-postulate-lean", "Generator" -> "wolfram/build_one_postulate_notebook.wl"|>
];

notebookPath = FileNameJoin[{notebooksDir, "one_postulate_explainer.nb"}];

Export[notebookPath, nb, "NB"];
exportSvgAsset["notebook_hero_overview.svg", heroOverviewGraphic];
exportSvgAsset["notebook_preview_branches.svg", branchPreviewGraphic];
exportSvgAsset["notebook_preview_killing_form.svg", killingPreviewGraphic];
exportSvgAsset["notebook_preview_spacetime.svg", spacetimePreviewGraphic];
exportSvgAsset["notebook_preview_crosswalk.svg", crosswalkGraphic];

Print["Wrote ", notebookPath];
Print["Wrote SVG assets to ", assetsDir];
