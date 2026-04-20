repoRoot = DirectoryName[DirectoryName[ExpandFileName[$InputFileName]]];
If[repoRoot === "." || repoRoot === "" || repoRoot === $Failed, repoRoot = Directory[]];
SetDirectory[repoRoot];

notebookPath = FileNameJoin[{repoRoot, "wolfram", "notebooks", "one_postulate_explainer.nb"}];

scriptArgs = Rest[$ScriptCommandLine];

envOrDefault[name_, default_] := Module[
  {value = Environment[name]},
  If[StringQ[value] && StringLength[StringTrim[value]] > 0, value, default]
];

cloudPath = If[
  Length[scriptArgs] >= 1 && StringLength[StringTrim[scriptArgs[[1]]]] > 0,
  scriptArgs[[1]],
  envOrDefault["ONE_POSTULATE_CLOUD_OBJECT", "one-postulate/one_postulate_explainer.nb"]
];

cloudPermissions = If[
  Length[scriptArgs] >= 2 && StringLength[StringTrim[scriptArgs[[2]]]] > 0,
  scriptArgs[[2]],
  envOrDefault["ONE_POSTULATE_CLOUD_PERMISSIONS", "Public"]
];

cloudObjectUrl[obj_CloudObject] := Module[
  {parts = List @@ obj},
  If[Length[parts] >= 1 && StringQ[First[parts]],
    First[parts],
    ToString[obj, InputForm]
  ]
];

If[! FileExistsQ[notebookPath],
  Print["Missing notebook: ", notebookPath];
  Print["Run wolframscript -file wolfram/build_one_postulate_notebook.wl first if you need to regenerate it."];
  Exit[1]
];

If[! TrueQ[$CloudConnected],
  Print["Connecting to Wolfram Cloud. Complete authentication if prompted."];
  CloudConnect[];
];

notebook = Import[notebookPath, "NB"];
If[Head[notebook] =!= Notebook,
  Print["Failed to import notebook as a Wolfram Notebook expression: ", notebookPath];
  Exit[1]
];

target = CloudObject[cloudPath];
Print["CloudExport source: ", notebookPath];
Print["CloudExport target: ", target];
Print["CloudExport permissions: ", cloudPermissions];

result = Quiet @ Check[
  CloudExport[notebook, "NB", target, Permissions -> cloudPermissions],
  $Failed
];

If[result === $Failed || Head[result] =!= CloudObject,
  Print["CloudExport failed."];
  Exit[1]
];

Print["CloudExport complete."];
Print["CloudObject: ", result];
Print["URL: ", cloudObjectUrl[result]];
