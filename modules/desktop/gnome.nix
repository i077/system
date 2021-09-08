{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.gnome;
  inherit (builtins) elem;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.desktop.gnome = { enable = mkEnableOption "GNOME Desktop"; };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        # Enable Wayland w/ NVIDIA graphics if necessary
        nvidiaWayland = elem config.modules.hardware.video.gpu [ "optimus" "nvidia" ];
      };
      desktopManager.gnome = {
        enable = true;

        # GNOME tools
        sessionPath = (with pkgs.gnome; [ dconf-editor gnome-tweaks ]) ++
          # Extensions
          (with pkgs.gnomeExtensions; [
            appindicator
            advanced-alttab-window-switcher
            blur-me
            dash-to-dock
            gsconnect
            night-theme-switcher
            paperwm
            vertical-overview
          ]);
      };
    };

    services.dbus.packages = [ pkgs.gnome.dconf ];

    environment.gnome.excludePackages = with pkgs.gnome;
      [
        gnome-software # No need for this since we use declarative nix
      ];

    # Enable gnome-settings-daemon udev rules
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    # Background selector
    hm.services.gnome-background = {
      enable = true;
      script = "/home/imran/Pictures/walls/selector.py";
      interval = "1h";
    };

    # Extra GNOME settings
    hm.dconf.settings = {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        # Remove max screencast length
        max-screencast-length = 0;
      };
    };
  };
}
