{ jq, stdenv, downloadMultipleRocPackages, roc }:

{ name ? "${args.pname}-${args.version}", src ? null
, rocDeps # list of {url,sha256} for all external deps of the roc program
, mainFile ? null, ... }@args:
let
  cleanedArgs = builtins.removeAttrs args [ "rocDeps" "mainFile" ];
  downloadedDeps = downloadMultipleRocPackages { inherit rocDeps; };

in stdenv.mkDerivation (cleanedArgs // {

  buildInputs = [ roc ];

  postPatch = ''
    for f in `find . -name "*.roc" -type f`; do
        ${jq}/bin/jq -r '[.url, .path] | @tsv' ${downloadedDeps}/roc-packages.json |
          while IFS=$'\t' read -r url path; do
            substituteInPlace $f \
              --replace "$url" "$path"
          done
    done
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p $out

    RUST_BACKTRACE=full ${roc}/bin/roc build --prebuilt-platform --linker=legacy

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # TODO: need to support other names
    mkdir -p $out/bin
    cp main $out/bin

    runHook postInstall
  '';
})

