{ config, lib, ... }:

let
  cfg = config.modules.desktop.utils.picom;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.utils.picom.enable = mkEnableOption "Picom compositor";

  config = mkIf cfg.enable {
    hm.services.picom = {
      enable = true;
      fade = true;
      fadeDelta = 5;
      shadow = true;
    };
  };
}
