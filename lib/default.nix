{ lib, newScope }:

lib.makeScope newScope (self:
let inherit (self) callPackage;
in {

  # Funcs external users will probably use
  buildRocApp = callPackage ./buildRocApp.nix { };
  bundleRocPlatform = callPackage ./bundleRocPlatform.nix { };


  # TODO: maybe call this set toolchain since we need the user to give us the roc cli
  # since roc is not in nix pkgs yet...
  overrideToolchain = toolchain:
    self.overrideScope' (_final: _prev: { roc = toolchain; });


  # internal funcs
  rocHelperFunctionsHook =
    callPackage ./setupHooks/rocHelperFunctions.nix { };
  downloadMultipleRocPackages =
    callPackage ./downloadMultipleRocPackages.nix { };
  downloadRocPackage = callPackage ./downloadRocPackage.nix { };
  mkRocDerivation = callPackage ./mkRocDerivation.nix { };
})
