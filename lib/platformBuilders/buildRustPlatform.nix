{ mkRocDerivation
, lib
, rustPlatform # from nix not roc...
, llvmPackages_16 # TODO: keep in sync with roc repo
, runCommand
, languageFilters
}:

let

  llvmPkgs = llvmPackages_16;
  fs = lib.fileset;
in


{ mainFile ? "./main.roc"
, pname
, version
, rustBuildOverrides ? { }
, ...
}@args:

let
  cleanedArgs = removeAttrs args [ "mainFile" "rustBuildOverrides" "pname" "version" "src" ];

  # TODO: allow just setting name
  rustBuildName = "${pname}-${version}-compile-rust";
  cBuildName = "${pname}-${version}-compile-c-host";

  # rustSrc = let basePath = fs.fromSource args.src; in
  # # fs.intersection basePath
  #   (languageFilters.rustFilter args.src);

  # TODO: probably move the rust build itself to diff file...
  rustBuildArgs = cleanedArgs // {
    src = fs.toSource {
      root = args.src; # TODO: would this get sad if the passed in src is the output of a derivation?
      fileset = languageFilters.rustFilter args.src;
    };
    name = rustBuildName;
    cargoBuildFlags = [
      "--lib"
    ];

    doCheck = false; #TODO: look into not doing this for now....
  };
  mergedRustArgs = lib.attrsets.recursiveUpdate rustBuildArgs (rustBuildOverrides);

  rustBuiltLib = rustPlatform.buildRustPackage mergedRustArgs;

  cHostDest = "c_host.o";
  compiledC =
    llvmPkgs.stdenv.mkDerivation
      {
        name = cBuildName;
        src = fs.toSource {
          root = args.src; # TODO: would this get sad if the passed in src is the output of a derivation?
          fileset = languageFilters.cFilter args.src;
        };

        buildPhase = ''
          runHook preBuild
          # $CC is clang since we are using llvmPkgs.stdenv
          # TODO: look into what is -fPIC -c doing....
          $CC host.c -o ${cHostDest} -fPIC -c
      
          mkdir -p $out
          cp ${cHostDest} $out

          runHook postBuild
        '';
      };

  # TODO: need to make a mapping for system to output o file name
  # see https://github.com/JRMurr/roc/blob/531af182899835a9298efd758b927e5ba3e2f64a/crates/compiler/build/src/link.rs#L57
  # TLDR linux-arm64.o | macos-arm64.o | linux-x64.o | linux-x64.o
  # should only really do all of them if making a package for external use
  # if only being used in a nix build we can keep it to just the system we are building for
  host_dest = "linux-x64.o";

  # TODO: expose this somehow so users can override
  rocCode = fs.toSource {
    root = args.src; # TODO: would this get sad if the passed in src is the output of a derivation?
    fileset = languageFilters.rocFilter args.src;
  };

in
llvmPkgs.stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  srcs = [
    rustBuiltLib
    compiledC
  ];

  sourceRoot = ".";

  buildPhase = ''
    $LD -r -L ${rustBuildName}/lib ${cBuildName}/${cHostDest} -lhost -o ${host_dest}

    mkdir -p $out
    cp ${host_dest} $out/${host_dest}
    cp -r ${rocCode}/. $out
  '';
}
