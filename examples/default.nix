{ pkgs, rocLib }:
let
  lib = pkgs.lib;
  callPackage = lib.callPackageWith (pkgs // { inherit rocLib; });
  # callPackage = pkgs.callPackage;
in
{
  simple = callPackage ./simple { };
  multiple-packages = callPackage ./multiple-packages { };
  build-a-platform = callPackage ./build-a-platform { };
}
