{ lib, newScope }:

lib.makeScope newScope (self:
  let inherit (self) callPackage;
  in {
    mkRocDerivation = callPackage ./mkRocDerivation.nix { };

    # TODO: maybe call this set toolchain since we need the user to give us the roc cli
    # since roc is not in nix pkgs yet...
    overrideToolchain = toolchain:
      self.overrideScope' (_final: _prev: { roc = toolchain; });
  })
