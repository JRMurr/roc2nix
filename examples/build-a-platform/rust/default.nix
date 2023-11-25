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
      "https://github.com/roc-lang/basic-cli/releases/download/0.6.0/QOQW08n38nHHrVVkJNiPIjzjvbR3iMjXeFY5w1aT46w.tar.br" = "sha256-ToGNR0+ZIaYZ0rwF0M2QyXcRdabi84/joa4wsaC3g0Y=";
    };
  };

in
{ inherit platform app; }
