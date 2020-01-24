{ config, lib, pkgs, ... }:

let
  myColors = import ../colors.nix;
  lockCommand = "${pkgs.xlockmore}/bin/xlock -mode fiberlamp -delay 50000 -erasedelay 0";

  mod = config.xsession.windowManager.i3.config.modifier;
  termExec = "${pkgs.alacritty}/bin/alacritty";
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

    keybindings = {
        # Restart i3
        "${mod}+Shift+r" = "restart";

        # Change focus
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move focused container
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Change split orientation
        "${mod}+z" = "split h";
        "${mod}+v" = "split v";
        # Fullscreen
        "${mod}+f" = "fullscreen toggle";

        # Kill focused container
        "${mod}+Shift+q" = "kill";

        # Change container layout
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        # Floating
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        # Sticky (stay on top of all workspaces)
        "${mod}+Ctrl+space" = "sticky toggle";

        # Focus parent/child container
        "${mod}+a" = "focus parent";
        "${mod}+Shift+a" = "focus child";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        # Move container to workspace
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # Scratchpad
        "${mod}+minus" = "scratchpad show";
        "${mod}+Shift+minus" = "move scratchpad";

        # Launcher
        "${mod}+d" = "exec rofi -show run";
        "${mod}+Shift+d" = "exec rofi -show drun";
        "${mod}+Tab" = "exec rofi -show window";
        # Password interface
        "${mod}+Shift+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";

        # Terminal
        "${mod}+Return" = "exec ${termExec}";
        "${mod}+Shift+Return" = "exec ${termExec} --class AlacrittyFloat";

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

        # Mode switching
        "${mod}+r" = "mode resize";
        "${mod}+o" = "mode launch";
        "${mod}+Escape" = "mode system";
      };

    modes = {
      resize = {
        # Coarse resize
        "h" = "resize shrink width 10px or 10 ppt";
        "j" = "resize grow height 10px or 10 ppt";
        "k" = "resize shrink height 10px or 10 ppt";
        "l" = "resize grow width 10px or 10 ppt";

        # Fine resize
        "Shift+h" = "resize shrink width 2px or 2 ppt";
        "Shift+j" = "resize grow height 2px or 2 ppt";
        "Shift+k" = "resize shrink height 2px or 2 ppt";
        "Shift+l" = "resize grow width 2px or 2 ppt";

        # Return to default
        "Escape" = "mode default";
        "Return" = "mode default";
        "${mod}+r" = "mode default";
      };

      launch = {
        "w" = "exec firefox --new-window; mode default";
        "Shift+w" = "exec ${pkgs.firefox}/bin/firefox --private-window; mode default";
        "e" = "exec ${termExec} -e ${config.home.sessionVariables.EDITOR}; mode default";
        "n" = "exec ${pkgs.write_stylus}/bin/Write; mode default";
        "g" = "exec ${pkgs.sublime-merge}/bin/sublime_merge; mode default";

        "Escape" = "mode default";
      };

      system = {
        "l" = "exec ${lockCommand}; mode default";
        "${mod}+Escape" = "exec ${lockCommand}; mode default";
        "e" = "exec i3-msg exit; mode default";
        "s" = "exec systemctl suspend; mode default";
        "Shift+s" = "exec systemctl poweroff";
        "Shift+r" = "exec systemctl reboot";
        
        "Escape" = "mode default";
      };
    };

    floating = {
      criteria = [
        { class = "^AlacrittyFloat$"; }
      ];
    };

    startup = [
      { command = "${pkgs.autorandr}/bin/autorandr -l main"; }
      { command = "systemctl --user restart polybar"; always = true; notification = false; }
    ];
  };

  # Cursor
  xsession.pointerCursor = {
    package = pkgs.pantheon.elementary-icon-theme;
    name = "elementary";
    size = 48;
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

  # Screen locker
  services.screen-locker = {
    enable = true;
    inactiveInterval = 15;
    xautolockExtraOptions = [
      "-corners +-+-" # Don't lock when mouse moves to right corners, lock when moves to left
      "-cornerdelay 2"
      "-cornerredelay 10"
      # "-bell 0" # No audio cues

      # "-notifier ${pkgs.libnotify}/bin/notify-send -u normal 'Screen will lock soon.'"
      # "-notify 10"
    ];
    lockCmd = lockCommand;
  };

  # Redshift at night
  services.redshift.enable = true;
}
