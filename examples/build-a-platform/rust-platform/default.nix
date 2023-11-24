{ rocLib
, lib
, rustPlatform # from nix not roc...
, runCommand
}:

# let
#   fs = lib.fileset;
#   # only grab roc and c files
#   fileSuffixes = [ ".roc" ".c" ];
#   filterfunc = file: (lib.lists.any (s: lib.hasSuffix s file.name) fileSuffixes);
#   sourceFiles = fs.fileFilter filterfunc ./.;

let

  tmp = rustPlatform.buildRustPackage {
    pname = "test";
    version = "0.0.1";

    src = ./.; # TODO: filter to rust only

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "roc_std-0.0.1" = "sha256-slt1TVyaFMUaFtQqHofgpLkchzEu5DH2HPxInRU14No=";
      };
    };

    # TODO: lib build will give a `libhost.a` file which seems to be used for linker=legacy

    cargoBuildFlags = [
      "--lib"

      # TODO: sad i assume its the build.rs file which is sad trying to find dylib=app
      # im pretty sure roc builds that so possible we can have a derivation before build it?
      # might need "-C link-args=-rdynamic" as rustc flag?
      # "--bin=host"
    ];

    doCheck = false;

  };

in

# in
  # rocLib.bundleRocPlatform {
  #   name = "rust-platform";
  #   version = "0.1.0";
  #   src = ./.;
  #   compressionType = "none";
  # }

runCommand "test-stuff" { } ''

  ls -la ${tmp}
  cp -r ${tmp} $out
''
