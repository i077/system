{ config, inputs, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.i3;
  hm = config.home-manager.users.${config.user.name};
  inherit (lib) mkDefault mkEnableOption mkIf;
  isHiDPI = config.modules.hardware.video.hidpi.enable;

  python3-i3 = pkgs.python3.withPackages (ps: with ps; [ i3ipc ]);
  myColors = config.modules.theming.colors;

  uiFont = with config.modules.theming.fonts;
    ui.family + " " + toString (ui.size * (if isHiDPI then 1 else 2));

  lockCommand = "${pkgs.xlockmore}/bin/xlock -mode fiberlamp -delay 50000 -erasedelay 0";

  mod = hm.xsession.windowManager.i3.config.modifier;
  termExec = config.modules.desktop.term.default;

  wsr = "${python3-i3}/bin/python ${inputs.i3-workspacer}/i3-workspacer.py";

  wsrGotoScript = pkgs.writeShellScript "i3-goto-workspace" ''
    i3-input -f "pango:${uiFont}" -F \
    "exec --no-startup-id ${wsr} go --exact --number \"%s\"" -P 'Go to workspace number: '
  '';
  wsrMovetoScript = pkgs.writeShellScript "i3-moveto-workspace" ''
    i3-input -f "pango:${uiFont}" -F \
    "exec --no-startup-id ${wsr} move --exact --number \"%s\"" -P 'Move container to workspace number: '
  '';
in {
  options.modules.desktop.i3.enable = mkEnableOption "i3 window manager";

  config = mkIf cfg.enable {
    hm.xsession.enable = true;

    # Enable desktop utilities by default, but make these overridable
    modules.desktop.utils = {
      autorandr.enable = mkDefault true;
      dunst.enable = mkDefault true;
      picom.enable = mkDefault true;
      polybar.enable = mkDefault true;
      redshift.enable = mkDefault true;
      rofi.enable = mkDefault true;
      wallpaper.enable = mkDefault true;
    };

    # Window manager
    services.xserver.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    hm.xsession.windowManager.i3.enable = true;
    hm.xsession.windowManager.i3.config = {
      modifier = "Mod4";

      gaps = {
        inner = 6;
        outer = 2;
      };

      bars = [ ];

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

      fonts = [ "Iosevka Nerd Font 9" "Jetbrains Mono 9" ];

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
        "${mod}+grave" = "exec --no-startup-id ${wsrGotoScript}";
        "${mod}+1" = "exec --no-startup-id ${wsr} go -n 1";
        "${mod}+2" = "exec --no-startup-id ${wsr} go -n 2";
        "${mod}+3" = "exec --no-startup-id ${wsr} go -n 3";
        "${mod}+4" = "exec --no-startup-id ${wsr} go -n 4";
        "${mod}+5" = "exec --no-startup-id ${wsr} go -n 5";
        "${mod}+6" = "exec --no-startup-id ${wsr} go -n 6";
        "${mod}+7" = "exec --no-startup-id ${wsr} go -n 7";
        "${mod}+8" = "exec --no-startup-id ${wsr} go -n 8";
        "${mod}+9" = "exec --no-startup-id ${wsr} go -n 9";
        "${mod}+0" = "exec --no-startup-id ${wsr} go -n 10";
        # Move container to workspace
        "${mod}+Shift+grave" = "exec --no-startup-id ${wsrMovetoScript}";
        "${mod}+Shift+1" = "exec --no-startup-id ${wsr} move -n 1";
        "${mod}+Shift+2" = "exec --no-startup-id ${wsr} move -n 2";
        "${mod}+Shift+3" = "exec --no-startup-id ${wsr} move -n 3";
        "${mod}+Shift+4" = "exec --no-startup-id ${wsr} move -n 4";
        "${mod}+Shift+5" = "exec --no-startup-id ${wsr} move -n 5";
        "${mod}+Shift+6" = "exec --no-startup-id ${wsr} move -n 6";
        "${mod}+Shift+7" = "exec --no-startup-id ${wsr} move -n 7";
        "${mod}+Shift+8" = "exec --no-startup-id ${wsr} move -n 8";
        "${mod}+Shift+9" = "exec --no-startup-id ${wsr} move -n 9";
        "${mod}+Shift+0" = "exec --no-startup-id ${wsr} move -n 10";
        # Navigate workspaces
        "${mod}+Ctrl+h" = "exec --no-startup-id ${wsr} go -d prev";
        "${mod}+Ctrl+j" = "exec --no-startup-id ${wsr} go -d up";
        "${mod}+Ctrl+k" = "exec --no-startup-id ${wsr} go -d down";
        "${mod}+Ctrl+l" = "exec --no-startup-id ${wsr} go -d next";
        # Move container to relative workspace
        "${mod}+Ctrl+Shift+h" = "exec --no-startup-id ${wsr} move -d prev";
        "${mod}+Ctrl+Shift+j" = "exec --no-startup-id ${wsr} move -d up";
        "${mod}+Ctrl+Shift+k" = "exec --no-startup-id ${wsr} move -d down";
        "${mod}+Ctrl+Shift+l" = "exec --no-startup-id ${wsr} move -d next";

        # Mark windows
        "${mod}+Shift+m" = "exec i3-input -F 'mark %s' -l 1 -P 'Mark: '";
        "${mod}+m" = "exec i3-input -F '[con_mark=\"%s\"] focus' -l 1 -P 'Goto mark: '";

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
        "Print" =
          "exec ${pkgs.maim}/bin/maim | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
        "Shift+Print" =
          "exec ${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
        "Shift+Ctrl+Print" =
          "exec ${pkgs.maim}/bin/maim -s ~/Pictures/scregion-$(date +%Y-%m-%dT%H-%M-%S).png";
        "Ctrl+Print" =
          "exec ${pkgs.maim}/bin/maim ~/Pictures/screen-$(date +%Y-%m-%dT%H-%M-%S).png";

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
          "e" = "exec ${termExec}; mode default";
          "f" = "exec ${termExec} -e ${pkgs.ranger}/bin/ranger; mode default";
          "g" = "exec ${pkgs.sublime-merge}/bin/sublime_merge; mode default";
          "n" = "exec ${pkgs.obsidian}/bin/obsidian; mode default";
          "t" = "exec ${pkgs.everdo}/bin/everdo; mode default";

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

      floating = { criteria = [ { class = "^AlacrittyFloat$"; } { class = "^everdo$"; } ]; };

      startup = [{
        command = "systemctl --user restart polybar";
        always = true;
        notification = false;
      }];

      workspaceAutoBackAndForth = true;
    };

    # Screen locker
    hm.services.screen-locker = {
      enable = true;
      inactiveInterval = 15;
      xautolockExtraOptions = [
        "-corners ++--" # Don't lock when mouse moves to lower corners, lock at upper corners
        "-cornerdelay 2"
        "-cornerredelay 10"
        # "-bell 0" # No audio cues

        # "-notifier ${pkgs.libnotify}/bin/notify-send -u normal 'Screen will lock soon.'"
        # "-notify 10"
      ];
      lockCmd = lockCommand;
    };
  };
}
