{ system ? builtins.currentSystem, ... }:

let
  pkgs = import <nixpkgs> { 
    inherit system;
    config.allowUnfree = true;
  };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    budspencer = callPackage ./budspencer.nix {};
    bobthefish = callPackage ./bobthefish.nix {};
    gnomeExtensions = import ./gnomeExtensions {};
    write_stylus = pkgs.libsForQt5.callPackage ./write_stylus {};
  };
in self
