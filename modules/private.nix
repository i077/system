# A module that defines the structure of all the private info in this repo.
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
  mkPrivOption = description:
    mkOption {
      inherit description;
      type = types.str;
    };
in {
  options.private = {
    u2fAuthFile = mkOption {
      description = "Path to file containing u2f keys";
      type = types.path;
    };

    authorizedYubikeysFile = mkOption {
      description = "Path to file containing yubikey tokens";
      type = types.path;
    };
  };

  config.private = import ../private.nix;
}
