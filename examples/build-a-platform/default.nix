{ rocLib, callPackage }: {
  c-platform = callPackage ./c-platform { inherit rocLib; };
}
