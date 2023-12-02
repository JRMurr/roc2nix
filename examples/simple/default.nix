{ rocLib, lib }:
let
  fs = lib.fileset;
  # only grab roc files
  sourceFiles = fs.fileFilter (file: lib.hasSuffix ".roc" file.name) ./.;

in
rocLib.buildRocApp {
  name = "simple-roc";
  version = "0.1.0";

  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };

  rocDeps = {
    "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" = "sha256-71jf2j6/0wsAuEKVJU+VJ+XwBNWvFvX6IkR3gjfbkX8=";
  };
}

