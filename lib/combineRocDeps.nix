{ runCommandLocal, downloadRocPackage, lib, jq, runCommand }:

{ rocDeps }:
let
  fetchOrTransform = url: val:
    lib.escapeShellArg (if builtins.isString val
    then
    # we only have the hash for the url need to fetch
      downloadedFileName url val
    else
    # we have a drv for the package just need to make some metadata for it
      transform url val);

  transform = url: val:
    let
      command = runCommand "transfrom-${url}" { } ''
        ${jq}/bin/jq --null-input \
          --arg url "${url}" \
          --arg path "${val}" \
          '{"url": $url, path: $path }' > $out/roc-package-info.json
      '';
    in
    "${command}/roc-package-info.json"
  ;

  downloadedFileName = url: sha256: "${downloadRocPackage {inherit url sha256;}}/roc-package-info.json";

  # jsonFiles =
  #   lib.concatMapStrings (p: "${lib.escapeShellArg (downloadedFileName p)} ")
  #     rocDeps;

  jsonFiles = lib.strings.concatStringsSep " " (lib.attrsets.attrValues (
    lib.attrsets.mapAttrs fetchOrTransform rocDeps
  ));

in
runCommandLocal "download-roc-packages" { } ''
  mkdir -p $out
  ${jq}/bin/jq -s '.' ${jsonFiles} > $out/roc-packages.json
''
