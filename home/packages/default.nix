{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    budspencer = callPackage ./budspencer.nix {};
    gnomeExtensions = import ./gnomeExtensions {};
  };
in self
