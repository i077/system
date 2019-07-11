{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    paperwm = callPackage ./paperwm {};
    timepp = callPackage ./timepp {};
    switcher = callPackage ./switcher {};
  };
in self
