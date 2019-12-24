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

    fonts = [ "Iosevka Nerd Font 9" "Inter UI 9" ];

    keybindings = let
        mod = config.xsession.windowManager.i3.config.modifier; 
      in lib.mkOptionDefault {
        # Launcher
        "${mod}+d" = "exec rofi -show run";
        "${mod}+Shift+d" = "exec rofi -show drun";
        "${mod}+Tab" = "exec rofi -show window";
        "${mod}+Shift+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";

        # Terminal
        "${mod}+Return" = "exec alacritty";
        "${mod}+Shift+Return" = "exec alacritty --class AlacrittyFloat";

        # Volume/media controls
        "XF86AudioRaiseVolume" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master 2%+ unmute";
        "XF86AudioLowerVolume" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master 2%- unmute";
        "XF86AudioMute" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master toggle";

        # Brightness controls
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86MonBrightnessDown" = "exec light -U 10";

        # Printscreen
        "Print" = "exec ${pkgs.maim}/bin/maim | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
        "Shift+Print" = "exec ${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
        "Ctrl+Print" = "exec ${pkgs.maim}/bin/maim ~/Pictures/screen-$(date +%Y-%m-%dT%H-%M-%S).png";
      };

    floating = {
      criteria = [
        { class = "^AlacrittyFloat$"; }
      ];
    };

    startup = [
      { command = "${pkgs.lightlocker}/bin/light-locker --idle-hint"; }
      { command = "systemctl --user restart polybar";
        always = true; notification = false; }
    ];
  };

  # Cursor
  xsession.pointerCursor = {
    package = pkgs.unstable.pantheon.elementary-icon-theme;
    name = "Elementary";
    size = 24;
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

  # Random backgrounds
  services.random-background = {
    enable = true;
    imageDirectory = "%h/Pictures/walls";
    interval = "6h";
  };

  # Redshift at night
  services.redshift.enable = true;
}
