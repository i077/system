{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.gnome3;
  inherit (builtins) elem;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.gnome3 = { enable = mkEnableOption "GNOME 3"; };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        # Enable Wayland w/ NVIDIA graphics if necessary
        nvidiaWayland = elem config.modules.hardware.video.gpu [ "optimus" "nvidia" ];
      };
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

    # Enable gnome-settings-daemon udev rules
    services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

    # Background selector
    hm.services.gnome-background = {
      enable = true;
      script = "/home/imran/Pictures/walls/selector.py";
      interval = "1h";
    };
  };
}
