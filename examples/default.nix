{ pkgs, rocLib }:
let callPackage = pkgs.callPackage;
in {
  simple = callPackage ./simple { inherit rocLib; };
  multiple-platforms = callPackage ./multiple-platforms { inherit rocLib; };
}
