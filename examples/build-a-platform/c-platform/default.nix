{ rocLib, lib }:

let
  fs = lib.fileset;
  # only grab roc and c files
  fileSuffixes = [ ".roc" ".c" ];
  filterfunc = file: (lib.lists.any (s: lib.hasSuffix s file.name) fileSuffixes);
  sourceFiles = fs.fileFilter filterfunc ./.;

in
rocLib.bundleRocPackage {
  name = "c-platform";
  version = "0.1.0";
  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };
}
