{ jq, stdenv, downloadMultipleRocPackages, rocHelperFunctionsHook }:

{ name ? "${args.pname}-${args.version}"
, src ? null
, rocDeps # list of {url,sha256} for all external deps of the roc program
, mainFile ? null
, # A command (likely a roc invocation) to run during the derivation's build
  # phase. Pre and post build hooks will automatically be run.
  buildPhaseRocCommand
, ...
}@args:
let
  cleanedArgs =
    builtins.removeAttrs args [ "rocDeps" "mainFile" "buildPhaseRocCommand" ];
  downloadedDeps = downloadMultipleRocPackages { inherit rocDeps; };

in
stdenv.mkDerivation (cleanedArgs // {

  nativeBuildInputs = [ rocHelperFunctionsHook ];

  # TODO: instead of doing this replace could we copy the deps the roc cache?
  # see https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/dart/fetch-dart-deps/setup-hook.sh for an example
  postPatch = ''
    for f in `find . -name "*.roc" -type f`; do
        ${jq}/bin/jq -r '(.[] | [.url, .path]) | @tsv' ${downloadedDeps}/roc-packages.json |
          while IFS=$'\t' read -r url path; do
            substituteInPlace $f \
              --replace "$url" "$path"
          done
    done
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p $out # TODO: move this out and let command do it?
    ${buildPhaseRocCommand}

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

