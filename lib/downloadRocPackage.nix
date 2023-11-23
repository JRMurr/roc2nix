{ fetchurl, runCommand }:

{ url, sha256 }:
let tarball = fetchurl { inherit url sha256; };
in runCommand "roc-package-download" { } ''
  mkdir -p $out
  echo '{"url": "${url}", "sha256": "${sha256}", "tar": "${tarball}"}' > $out/roc-package-info.json
''
