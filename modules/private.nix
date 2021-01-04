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
    everdo = mkOption {
      description = ''
        Everdo configuration.
        Attributes map to contents of files in $XDG_CONFIG_HOME/everdo.
      '';
      type = types.submodule {
        options = {
          key = mkPrivOption "Everdo product key";
          encryptionKey = mkPrivOption "ESS passphrase";
          jwt = mkPrivOption "ESS access token";
        };
      };
    };

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
