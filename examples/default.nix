{ pkgs, rocLib }:
let callPackage = pkgs.callPackage;
in { simple = callPackage ./simple.nix { inherit rocLib; }; }
