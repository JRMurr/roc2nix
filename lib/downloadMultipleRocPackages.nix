{ runCommandLocal, downloadRocPackage, lib, jq }:

{ rocDeps }:
let
  downloadedFileName = p: "${downloadRocPackage p}/roc-package-info.json";

  jsonFiles =
    lib.concatMapStrings (p: "${lib.escapeShellArg (downloadedFileName p)} ")
      rocDeps;

in
runCommandLocal "download-roc-packages" { } ''
  mkdir -p $out
  ${jq}/bin/jq -s '.' ${jsonFiles} > $out/roc-packages.json
''
