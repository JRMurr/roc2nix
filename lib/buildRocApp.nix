{ mkRocDerivation }:

{ rocBuildCommand ? "roc build --prebuilt-platform --linker=legacy"
  # , cargoExtraArgs ? "--locked"
  # , cargoTestCommand ? "cargoWithProfile test"
  # , cargoTestExtraArgs ? ""
, ... }@args:
let
  cleanedArgs = removeAttrs args [
    "rocBuildCommand"
    # "cargoExtraArgs"
    # "cargoTestCommand"
    # "cargoTestExtraArgs"
    # "outputHashes"
  ];

in mkRocDerivation (args // {
  buildPhaseRocCommand = args.buildPhaseRocCommand or ''
    ${rocBuildCommand}
  '';
})
# roc build --prebuilt-platform --linker=legacy
