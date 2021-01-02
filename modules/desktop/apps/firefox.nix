{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.apps.firefox;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.apps.firefox.enable = mkEnableOption "Mozilla Firefox";

  config = mkIf cfg.enable {
    hm.programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        extraNativeMessagingHosts = with pkgs; [ passff-host tridactyl-native ];
      };
    };

    hm.home.sessionVariables = { MOZ_USE_XINPUT2 = 1; };
  };
}
