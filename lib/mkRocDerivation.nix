{ stdenv, roc }:

{ name ? "${args.pname}-${args.version}", src ? null
, rocDeps # list of {url,sha256} for all external deps of the roc program
, ... }@args:
let
in stdenv.mkDerivation args // {

  postUnPackPhase = ''
    ls -la $src
    ls -la ${roc}
    echo asd
  '';

  buildPhase = ''
    runhook preBuildPhase



    runhook postBuildPhase
  '';
}

