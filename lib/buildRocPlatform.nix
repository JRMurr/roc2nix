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
  cleanedArgs = removeAttrs args [ "rocBuildCommand" "rocExtraArgs" "compressionType" "mainFile" ];
  tarSuffix = if compressionType == "none" then "" else ".${compressionType}";
  bundleStr = ".tar${tarSuffix}";
in
assert lib.asserts.assertOneOf "compressionType" compressionType validCompressionTypes;

mkRocDerivation
  (cleanedArgs // {
    buildPhaseRocCommand = args.buildPhaseRocCommand or ''
      roc build --prebuilt-platform --linker=legacy --bundle ${bundleStr} ${mainFile} ${rocExtraArgs}
    '';

    installPhaseCommand = args.installPhaseCommand or ''
      mkdir -p $out
      ls -la .

      # TODO: potential to grab other tars if the src had them
      # should probably capture the name from the roc build stdout to only grab the bundle we just made
      find . -name '*${bundleStr}' | while IFS= read -r FILE; do
          echo "Copying $FILE"
          cp "$FILE" $out
      done
    '';
  })
