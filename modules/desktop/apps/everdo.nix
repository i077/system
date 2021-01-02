{ config, pkgs, lib, ... }:

let
  cfg = config.modules.desktop.apps.everdo;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.apps.everdo.enable = mkEnableOption "Everdo";

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.everdo ];

    hm.xdg.configFile = {
      "everdo/everdo.key".text = config.private.everdo.key;
      "everdo/encryption-key".text = config.private.everdo.encryptionKey;
      "everdo/jwt".text = config.private.everdo.jwt;
    };
  };
}
