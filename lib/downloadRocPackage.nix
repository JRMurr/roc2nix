{ jq, brotli, fetchurl, runCommand }:

{ url, sha256 }:
let tarball = fetchurl { inherit url sha256; };

in runCommand "roc-package-download" { } ''
  mkdir -p $out/package

  ${brotli}/bin/brotli --decompress --stdout ${tarball} | tar -C $out/package -x

  echo $out/package/main.roc


  ${jq}/bin/jq --null-input \
    --arg url "${url}" \
    --arg path "$out/package/main.roc" \
    '{"url": $url, path: $path }' > $out/roc-package-info.json
''
