# roc2Nix

not working yet :(


Right now the user must specify all the url deps to the builder like so
```nix
let
  fs = lib.fileset;
  # only grab roc files
  sourceFiles = fs.fileFilter (file: lib.hasSuffix ".roc" file.name) ./.;

in rocLib.mkRocDerivation {
  name = "simple-roc";
  version = "0.1.0";

  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };

  rocDeps = [{
    sha256 = "sha256-ToGNR0+ZIaYZ0rwF0M2QyXcRdabi84/joa4wsaC3g0Y=";
    url =
      "https://github.com/roc-lang/basic-cli/releases/download/0.6.0/QOQW08n38nHHrVVkJNiPIjzjvbR3iMjXeFY5w1aT46w.tar.br";
  }];
}
```

this lib will then call `fetchUrl` to get a nix store path for the url and replace all uses of that url with the nix store path instead.


See examples/simple for what the desired api is like.




Lib setup is heavily inspired by [crane](https://github.com/ipetkov/crane)