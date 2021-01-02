# modules/devel/android.nix -- Android development tools

{ config, lib, pkgs, options, ... }:

let
  cfg = config.modules.devel.android;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.devel.android.enable = mkEnableOption "Android development tools";

  config = mkIf cfg.enable {
    # Android Studio + ADB
    hm.home.packages = with pkgs; [ android-studio ];
    programs.adb.enable = true;

    # Grant user access to ADB
    user.extraGroups = [ "adbusers" ];
    services.udev.packages = with pkgs; [ android-udev-rules ];
  };
}
