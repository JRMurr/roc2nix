{ rocLib, lib }:

let
  fs = lib.fileset;
  # only grab roc and c files
  fileSuffixes = [ ".roc" ".c" ];
  filterfunc = file: lib.list.any (s: lib.hasSuffix s file) fileSuffixes;
  sourceFiles = fs.fileFilter filterfunc ./.;

in rocLib.mkRocDerivation {
  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };
}
