{ mkRocDerivation }:

{ rocBuildCommand ? "roc build --prebuilt-platform --linker=legacy"
, rocExtraArgs ? ""
, ...
}@args:
let cleanedArgs = removeAttrs args [ "rocBuildCommand" "rocExtraArgs" ];

in mkRocDerivation (args // {
  buildPhaseRocCommand = args.buildPhaseRocCommand or ''
    ${rocBuildCommand} ${rocExtraArgs}
  '';
})
