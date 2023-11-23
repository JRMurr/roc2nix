{ jq, stdenv, downloadMultipleRocPackages, roc }:

{ name ? "${args.pname}-${args.version}", src ? null
, rocDeps # list of {url,sha256} for all external deps of the roc program
, mainFile ? null, ... }@args:
let
  cleanedArgs = builtins.removeAttrs args [ "rocDeps" "mainFile" ];
  downloadedDeps = downloadMultipleRocPackages { inherit rocDeps; };

in stdenv.mkDerivation (cleanedArgs // {

  postPatch = ''
    for f in `find . -name "*.roc" -type f`; do
        ${jq}/bin/jq -r '[.url, .tar] | @tsv' ${downloadedDeps}/roc-packages.json |
          while IFS=$'\t' read -r url tar; do
            substituteInPlace $f \
              --replace "$url" "$tar"
          done
    done
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p $out

    ${roc}/bin/roc build --prebuilt-platform --max-threads 1

    runHook postBuild
  '';
})

