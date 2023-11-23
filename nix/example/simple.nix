{ buildRocPackge, lib }:
let
  fs = lib.fileset;
  # only grab roc files
  # sourceFiles = fs.fileFilter (file: lib.hasSuffix ".roc" file.name);
  sourceFiles = fs.unions [ ./simple.roc ];

  # roc-pkgs = {
  #   basic-cli = {
  #     sha256 = "sha256-ToGNR0+ZIaYZ0rwF0M2QyXcRdabi84/joa4wsaC3g0Y=";
  #     url =
  #       "https://github.com/roc-lang/basic-cli/releases/download/0.6.0/QOQW08n38nHHrVVkJNiPIjzjvbR3iMjXeFY5w1aT46w.tar.br";
  #   };
  #   # others...
  # };
  rocDeps = [{
    sha256 = "sha256-ToGNR0+ZIaYZ0rwF0M2QyXcRdabi84/joa4wsaC3g0Y=";
    url =
      "https://github.com/roc-lang/basic-cli/releases/download/0.6.0/QOQW08n38nHHrVVkJNiPIjzjvbR3iMjXeFY5w1aT46w.tar.br";
  }];
in buildRocPackge {

  name = "foo";
  version = "0.1.0";

  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };

}
