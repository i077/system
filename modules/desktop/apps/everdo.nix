{ config, pkgs, lib, ... }:

let
  cfg = config.modules.desktop.apps.everdo;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.apps.everdo.enable = mkEnableOption "Everdo";

  config = mkIf cfg.enable {
    # Declare secrets
    sops.secrets.everdo-key.owner = config.user.name;
    sops.secrets.everdo-encryptionkey.owner = config.user.name;
    sops.secrets.everdo-jwt.owner = config.user.name;

    hm.home.packages = [ pkgs.everdo ];

    hm.home.activation."everdoSecrets" = {
      before = [ ];
      after = [ "linkGeneration" ];
      data = with config.sops.secrets; ''
        ln -sf ${everdo-key.path} $XDG_CONFIG_HOME/everdo/everdo.key
        ln -sf ${everdo-encryptionkey.path} $XDG_CONFIG_HOME/everdo/encryption-key
        ln -sf ${everdo-jwt.path} $XDG_CONFIG_HOME/everdo/jwt
      '';
    };
  };
}
