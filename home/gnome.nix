{ config, pkgs, ... }:

{
  dconf.settings = {
    # Night light
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = 4000;
    };

    # Enabled extensions
    "org/gnome/shell" = {
      enabled-extensions = [
      	"alternate-tab@gnome-shell-extensions.gcampax.github.com"
      	"user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "caffeine@patapon.info"
        "timepp@zagortenay333"
      ];
    };

    # Dash to dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
      intellihide-mode = "ALL_WINDOWS";
    };
  };
}
