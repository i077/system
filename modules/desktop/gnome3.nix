{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.gnome3;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.gnome3 = { enable = mkEnableOption "GNOME 3"; };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;
    };

    services.dbus.packages = [ pkgs.gnome3.dconf ];

    # GNOME tools
    environment.systemPackages = (with pkgs.gnome3; [ dconf-editor ]) ++
      # Extensions
      (with pkgs.gnomeExtensions; [
        appindicator
        dash-to-dock
        gsconnect
        night-theme-switcher
        paperwm
      ]);

    environment.gnome3.excludePackages = with pkgs.gnome3;
      [
        gnome-software # No need for this since we use declarative nix
      ];

    hm.home.packages = with pkgs; [ gnome3.gnome-tweaks ];

    # Background selector
    hm.services.gnome-background = {
      enable = true;
      script = "/home/imran/Pictures/walls/selector.py";
      interval = "1h";
    };
  };
}
