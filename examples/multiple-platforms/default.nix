{ rocLib, lib }:
let
  fs = lib.fileset;
  # only grab roc files
  sourceFiles = fs.fileFilter (file: lib.hasSuffix ".roc" file.name) ./.;

in rocLib.mkRocPackage {
  name = "multiple-platforms-roc";
  version = "0.1.0";

  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };

  rocDeps = [
    {
      sha256 = "sha256-ToGNR0+ZIaYZ0rwF0M2QyXcRdabi84/joa4wsaC3g0Y=";
      url =
        "https://github.com/roc-lang/basic-cli/releases/download/0.6.0/QOQW08n38nHHrVVkJNiPIjzjvbR3iMjXeFY5w1aT46w.tar.br";
    }
    {
      sha256 = "sha256-JDD9F9YbyYVervw2tZp3L6y0JO6sGWG6lp6w0npAObg=";
      url =
        "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.2.0/dJQSsSmorujhiPNIvJKlQoI92RFIG_JQwUfIxZsCSwE.tar.br";
    }
  ];
}
