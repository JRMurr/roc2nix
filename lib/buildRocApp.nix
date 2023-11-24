{ mkRocDerivation }:

{ rocBuildCommand ? "roc build --prebuilt-platform --linker=legacy"
, rocExtraArgs ? ""
, ...
}@args:
let cleanedArgs = removeAttrs args [ "rocBuildCommand" "rocExtraArgs" ];

in mkRocDerivation (cleanedArgs // {
  buildPhaseRocCommand = args.buildPhaseRocCommand or ''
    ${rocBuildCommand} ${rocExtraArgs}
  '';


  installPhaseCommand = args.installPhaseCommand or ''
    # TODO: need to support other names
    mkdir -p $out/bin
    cp main $out/bin
  '';
})
