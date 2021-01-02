{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.hardware.keyboard;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.modules.hardware.keyboard = {
    caps2esc.enable = mkEnableOption "caps2esc service";
    ergodox.enable = mkEnableOption "Ergodox-related configuration";
  };

  config = mkMerge [
    {
      assertions = [{
        # Ergodox keyboards encompass caps2esc functionality since they're flashable,
        # so it doesn't make sense to enable both.
        assertion = !(cfg.caps2esc.enable && cfg.ergodox.enable);
        message =
          "Can't have both caps2esc and ergodox options enabled. If the device has an Ergodox keyboard, disable caps2esc.";
      }];
    }

    (mkIf cfg.caps2esc.enable {
      services.interception-tools = {
        enable = true;
        plugins = with pkgs.interception-tools-plugins; [ caps2esc ];
      };
    })

    (mkIf cfg.ergodox.enable { hm.home.packages = with pkgs; [ wally-cli ]; })
  ];

}
