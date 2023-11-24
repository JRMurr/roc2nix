{ rocLib }:

# let
#   fs = lib.fileset;
#   # only grab roc and c files
#   fileSuffixes = [ ".roc" ".c" ];
#   filterfunc = file: (lib.lists.any (s: lib.hasSuffix s file.name) fileSuffixes);
#   sourceFiles = fs.fileFilter filterfunc ./.;

rocLib.buildRustPlatform {
  pname = "test";
  version = "0.0.1";

  src = ./.; # TODO: filter to rust only

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "roc_std-0.0.1" = "sha256-slt1TVyaFMUaFtQqHofgpLkchzEu5DH2HPxInRU14No=";
    };
  };
}
