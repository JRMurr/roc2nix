{ rocLib, callPackage }: {
  c-platform = callPackage ./c-platform { inherit rocLib; };
  rust-platform = callPackage ./rust-platform { inherit rocLib; };

}
