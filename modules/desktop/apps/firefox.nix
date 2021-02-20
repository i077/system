{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.firefox;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.apps.firefox.enable = mkEnableOption "Mozilla Firefox";

  config = mkIf cfg.enable {
    hm.programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        forceWayland = true;
        extraNativeMessagingHosts = with pkgs; [ passff-host tridactyl-native ];
      };
    };

    hm.home.sessionVariables = {
      MOZ_USE_XINPUT2 = 1;
      MOZ_ENABLE_WAYLAND = 1;
    };
  };
}
