# This is an impure recreation of the currently deployed NixOS configuration
# from flake.nix, using the current system's hostname to determine the correct
# attribute from the set of NixOS configurations. It is intended for importing
# from <nixpkgs/nixos> on an already running system and producing roughly the
# same configuration as nixos-rebuild. It is NOT meant for building an actual
# configuration.

{ lib, pkgs, ... }:

let
  hostname = lib.fileContents /etc/hostname;
  devicename = lib.removePrefix "i077-" hostname;

in {
  _module.args = {
    device = import (./hosts + "/${devicename}");

    # Read in flake inputs from /etc/sources
    inputs = lib.mapAttrs (n: v: "/etc/sources/${n}") (builtins.readDir /etc/sources);
  };

  networking.hostName = hostname;

  system.stateVersion = "19.03";

  imports = [
    /etc/sources/home-manager/nixos
    (./hosts + "/${devicename}/hardware-configuration.nix")
    ./packages
    ./modules
  ];
}
