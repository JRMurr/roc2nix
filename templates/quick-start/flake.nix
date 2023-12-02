{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    roc.url = "github:roc-lang/roc";
    roc2nix = {
      url = "github:JRMurr/roc2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.roc.follows = "roc";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, roc, roc2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # For now you need to manually set the roc cli when you get the lib
        rocPkgs = roc.packages.${system};
        rocLib = (roc2nix.lib.${system}).overrideToolchain rocPkgs.cli;

        compiledApp =
          let
            fs = pkgs.lib.fileset;
            # only grab roc files
            sourceFiles = fs.fileFilter (file: pkgs.lib.hasSuffix ".roc" file.name) ./src;
          in
          rocLib.buildRocApp {
            name = "multiple-platforms-roc";
            version = "0.1.0";

            src = fs.toSource {
              root = ./src;
              fileset = sourceFiles;
            };

            rocDeps = {
              "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" = "sha256-71jf2j6/0wsAuEKVJU+VJ+XwBNWvFvX6IkR3gjfbkX8=";
              "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.2.0/dJQSsSmorujhiPNIvJKlQoI92RFIG_JQwUfIxZsCSwE.tar.br" = "sha256-JDD9F9YbyYVervw2tZp3L6y0JO6sGWG6lp6w0npAObg = ";
            };
          };


      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs;
              [
                rocPkgs.cli

                # add compiledApp here and `main` will be exposed when you run `nix develop`
                # I would not reccomend doing this for a program you are changing often on
              ];
          };
        };

        packages = { default = compiledApp; };
      });
}

