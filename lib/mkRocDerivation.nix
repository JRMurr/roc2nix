{ stdenv, downloadMultipleRocPackages, roc }:

{ name ? "${args.pname}-${args.version}", src ? null
, rocDeps # list of {url,sha256} for all external deps of the roc program
, mainFile ? null, ... }@args:
let
  cleanedArgs = builtins.removeAttrs args [ "rocDeps" "mainFile" ];
  downloadedDeps = downloadMultipleRocPackages { inherit rocDeps; };

in stdenv.mkDerivation (cleanedArgs // {

  # TODO: should we do the change in postPatch instead?
  postPatch = ''
    echo ${downloadedDeps}
    for f in `find . -name "*.roc" -type f`; do
        echo "$f"
        # substituteInPlace $f
    done
  '';

  buildPhase = ''
    runhook preBuild

    mkdir -p $out

    runHook postBuild
  '';
})

