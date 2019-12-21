{ config, lib, pkgs, ... }:

let
  myColors = import ../colors.nix;
in lib.mkIf config.xsession.windowManager.i3.enable {
  xsession.windowManager.i3.config = {
    modifier = "Mod4";

    gaps = {
      inner = 6;
      outer = 2;
    };

    bars = [];

    colors = with myColors; {
      background = bg0;
      focused = {
        border = primary;
        background = bg1;
        text = fg0;
        indicator = tertiary;
        childBorder = primary;
      };
      focusedInactive = {
        border = primary;
        background = bg0;
        text = primary;
        indicator = tertiary;
        childBorder = primary;
      };
      unfocused = {
        border = bg0;
        background = bg3;
        text = primary;
        indicator = tertiary;
        childBorder = bg0;
      };
      urgent = {
        border = alert;
        background = alert;
        text = fg0;
        indicator = alert;
        childBorder = alert;
      };
    };
  };

  # Automatic display configuration
  programs.autorandr.enable = true;

  # Launcher/dmenu replacement
  programs.rofi.enable = true;

  # Smoother compositing
  services.compton.enable = true;

  # Notifications
  services.dunst.enable = true;

  # Status bar
  services.polybar.enable = true;
}
