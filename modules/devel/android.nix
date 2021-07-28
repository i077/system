# modules/devel/android.nix -- Android development tools

{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.devel.android;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.modules.devel.android = {
    enable = mkEnableOption "Android development tools";
    studio.enable = mkEnableOption "Android Studio";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Android Studio + ADB
      programs.adb.enable = true;

      # Grant user access to ADB
      user.extraGroups = [ "adbusers" ];
      services.udev.packages = with pkgs; [ android-udev-rules ];
    }

    (mkIf cfg.studio.enable { hm.home.packages = with pkgs; [ android-studio ]; })
  ]);
}
