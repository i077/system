{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.rclone;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.rclone.enable = mkEnableOption "rclone";

  config = mkIf cfg.enable {
    # Base rclone.conf to copy from
    sops.secrets.rclone-conf.owner = config.user.name;

    # Add rclone to home environment
    hm.home.packages = [ pkgs.rclone ];

    # Copy and set appropriate permissions
    hm.home.activation."rcloneConf" = {
      before = [ ];
      after = [ "linkGeneration" ];
      data = ''
        cp ${config.sops.secrets.rclone-conf.path} $XDG_CONFIG_HOME/rclone/rclone.conf
        chown ${config.user.name} $XDG_CONFIG_HOME/rclone/rclone.conf
        chmod 600 $XDG_CONFIG_HOME/rclone/rclone.conf
      '';
    };
  };
}
