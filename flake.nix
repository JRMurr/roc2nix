{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    roc.url = "github:roc-lang/roc";
  };

  outputs = { self, nixpkgs, flake-utils, roc, ... }:
    let mkLib = pkgs: import ./lib { inherit (pkgs) lib newScope; };
    in flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs { inherit system; };
        rocPkgs = roc.packages.${system};

        lib = mkLib pkgs;

        examples = import ./examples {
          inherit pkgs;
          rocLib = lib.overrideToolchain rocPkgs.cli;
        };

      in
      {
        formatter = pkgs.nixpkgs-fmt;
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ nix-prefetch rocPkgs.cli ];
          };
        };

        packages = {
          examples-simple = examples.simple;
          examples-multiple-platforms = examples.multiple-platforms;
        };
      });
}
