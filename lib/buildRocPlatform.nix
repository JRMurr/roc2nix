{ mkRocDerivation, lib }:

let
  validCompressionTypes = [ "br" "gz" "none" ];
in

{ mainFile ? "./main.roc"
, compressionType ? builtins.head validCompressionTypes
, rocExtraArgs ? ""
, ...
}@args:
let
  cleanedArgs = removeAttrs args [ "rocBuildCommand" "rocExtraArgs" ];
  tarSuffix = if compressionType == "none" then "" else ".${compressionType}";
  bundleStr = ".tar${tarSuffix}";
in
assert lib.asserts.assertOneOf "compressionType" compressionType validCompressionTypes;
mkRocDerivation (args // {
  buildPhaseRocCommand = args.buildPhaseRocCommand or ''
    roc build --prebuilt-platform --linker=legacy --bundle ${bundleStr} ${mainFile} ${rocExtraArgs}
  '';
})
