{ lib }:

# common file sets for different languages
# https://nix.dev/tutorials/file-sets
# https://nixos.org/manual/nixpkgs/unstable/#sec-functions-library-fileset
with lib.fileset;

let

  fileHasAnySuffix = fileSuffixes: file: (lib.lists.any (s: lib.hasSuffix s file.name) fileSuffixes);

  rustFilter = basePath: (
    let
      mainFilter = fileFilter
        (fileHasAnySuffix [ ".rs" ".toml" ])
        basePath;
    in
    unions [ mainFilter (basePath + "/Cargo.toml") (basePath + "/Cargo.lock") ]
  );

  cFilter = basePath: fileFilter (fileHasAnySuffix [ ".c" ]) basePath;

  rocFilter = basePath: fileFilter (fileHasAnySuffix [ ".roc" ]) basePath;
in
{
  inherit rustFilter cFilter rocFilter;
}
