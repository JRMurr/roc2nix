{ rocLib, callPackage }: {
  # the actual platforms
  c-platform = callPackage ./c-platform { inherit rocLib; };
  rust-platform = callPackage ./rust { inherit rocLib; };

  # apps with the plaforms
  rust-app = callPackage ./rust-platform { inherit rocLib; };
}
