{ config, lib, pkgs, ... }:

{
  home-manager.users.imran = {
    # Add rclone to home environment
    home.packages = [ pkgs.rclone ];

    xdg.configFile."rclone/rclone.conf.hm".text = let
      rcloneINI = with lib.generators;
        toINI {
          mkKeyValue =
            mkKeyValueDefault { mkValueString = v: mkValueStringDefault { } v; }
            "=";
        };
    in rcloneINI config.private.rcloneConf;

    # Copy and set appropriate permissions
    home.activation."rcloneConf" = {
      before = [ ];
      after = [ "linkGeneration" ];
      data = ''
        cp ./.config/rclone/rclone{.conf.hm,.conf}
        chmod 700 ./.config/rclone/rclone.conf
      '';
    };
  };
}
