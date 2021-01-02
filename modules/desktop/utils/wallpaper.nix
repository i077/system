{ config, lib, ... }:

let
  cfg = config.modules.desktop.utils.wallpaper;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.utils.wallpaper.enable = mkEnableOption "Wallpaper selector";

  config = mkIf cfg.enable {
    hm.services.random-background = {
      enable = true;
      imageDirectory = "%h/Pictures/walls";
      interval = "6h";
    };
  };
}
