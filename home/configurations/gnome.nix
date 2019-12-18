{ config, pkgs, ... }:

{
  dconf.settings = {
    # Night light
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = 4000;
    };

    # Top bar stuff
    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      show-battery-percentage = true;
    };

    # Enabled extensions
    "org/gnome/shell" = {
      enabled-extensions = [
        "alternate-tab@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        "dash-to-dock@micxgx.gmail.com"
        "mprisindicatorbutton@JasonLG1979.github.io"
        "nightthemeswitcher@romainvigier.fr"
        "paperwm@hedning:matrix.org"
        "switcher@landau.fi"
        "TopIcons@phocean.net"
        "gsconnect@andyholmes.github.io"
      ];
    };

    # Dash to dock settings
    "org/gnome/shell/extensions/dash-to-dock" = {
      intellihide-mode = "ALL_WINDOWS";
    };

    # For PaperWM
    "org/gnome/shell/overrides" = {
      attach-modal-dialogs = false;
      edge-tiling = false;
      workspaces-only-on-primary = false;
    };
    "org/gnome/mutter" = {
      auto-maximize = false;
    };
  };
}
