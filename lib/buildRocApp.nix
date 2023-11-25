{ mkRocDerivation, lib }:

{
  # the file to pass to roc build
  mainFile ? "main.roc"
, rocBuildCommand ? "roc build --prebuilt-platform --linker=legacy ${mainFile}"
, rocExtraArgs ? ""

, ...
}@args:
let
  cleanedArgs = removeAttrs args [ "rocBuildCommand" "rocExtraArgs" ];
  # TODO: make this customizeable? User could pass in extraRocArg that changes the bin name
  outputtedBinaryName = lib.strings.removeSuffix ".roc" mainFile;
in
mkRocDerivation (cleanedArgs // {
  buildPhaseRocCommand = args.buildPhaseRocCommand or ''
    ${rocBuildCommand} ${rocExtraArgs}
  '';


  installPhaseCommand = args.installPhaseCommand or ''
    mkdir -p $out/bin
    cp ${outputtedBinaryName} $out/bin
  '';
})
