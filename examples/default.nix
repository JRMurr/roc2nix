{ pkgs, rocLib }:
let callPackage = pkgs.callPackage;
in { simple = callPackage ./simple { inherit rocLib; }; }
