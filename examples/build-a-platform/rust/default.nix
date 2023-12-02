{ callPackage, rocLib, lib }:
let
  fs = lib.fileset;

  platform = callPackage ./platform { inherit rocLib; };

  app = rocLib.buildRocApp {
    name = "roc-rust";
    version = "0.1.0";
    mainFile = "rocLovesRust.roc";

    src = fs.toSource {
      root = ./.;
      fileset = fs.fileFilter (file: lib.hasSuffix ".roc" file.name) ./.;
    };

    rocDeps = {
      "rust-platform" = platform;
      "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" = "sha256-71jf2j6/0wsAuEKVJU+VJ+XwBNWvFvX6IkR3gjfbkX8=";
    };
  };

in
{ inherit platform app; }

