{ config, lib, ... }:

let
  cfg = config.modules.desktop.utils.redshift;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.utils.redshift.enable = mkEnableOption "Redshift";

  config = mkIf cfg.enable {
    hm.services.redshift = {
      enable = true;

      # Leave icon in tray
      tray = true;

      provider = "geoclue2";
      temperature = {
        day = 6500;
        night = 3700;
      };
    };
  };
}
