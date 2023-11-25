{ rocLib, callPackage }:
let
  rustExample = callPackage ./rust { inherit rocLib; };
in
{
  # the actual platforms
  c-platform = callPackage ./c-platform { inherit rocLib; };
  rust-platform = rustExample.platform;

  # apps with the plaforms
  rust-app = rustExample.app;
}
