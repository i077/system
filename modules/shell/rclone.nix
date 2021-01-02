{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.rclone;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.shell.rclone.enable = mkEnableOption "rclone";

  config = mkIf cfg.enable {
    # Add rclone to home environment
    hm.home.packages = [ pkgs.rclone ];

    hm.xdg.configFile."rclone/rclone.conf.hm".text = let
      rcloneINI = with lib.generators;
        toINI {
          mkKeyValue = mkKeyValueDefault { mkValueString = v: mkValueStringDefault { } v; } "=";
        };
    in rcloneINI config.private.rcloneConf;

    # Copy and set appropriate permissions
    hm.home.activation."rcloneConf" = {
      before = [ ];
      after = [ "linkGeneration" ];
      data = ''
        cp $XDG_CONFIG_HOME/rclone/rclone{.conf.hm,.conf}
        chmod 700 $XDG_CONFIG_HOME/rclone/rclone.conf
      '';
    };
  };
}
