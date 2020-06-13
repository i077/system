{ config, device, pkgs, ... }:

let inherit (config.theming) colors;
in {
  home-manager.users.imran.services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3GapsSupport =
        config.home-manager.users.imran.xsession.windowManager.i3.enable;
      pulseSupport = true;
    };

    script = "polybar bar1 &";

    config = {
      # TODO Device-specific bars
      "bar/bar1" = {
        monitor = {
          spectre = "\${env:MONITOR:eDP1}";
          tower = "\${env:MONITOR:DP-4}";
        }.${device.name};
        dpi = 100 * (if device.isHiDPI then 2 else 1);
        bottom = true;
        width = "100%";
        height = 24 * (if device.isHiDPI then 2 else 1);
        radius = 0;
        fixed-center = false;
        padding-left = 0;
        padding-right = 0;
        module-margin-left = 1;
        module-margin-right = 1;

        font-0 = with config.theming.fonts;
          "${mono.family}:size=${toString mono.size}";
        font-1 = with config.theming.fonts;
          "Iosevka Nerd Font:size=${toString mono.size}";
        wm-restack = "i3";

        tray-position = "right";
        tray-maxsize = 16 * (if device.isHiDPI then 2 else 1);
        tray-background = colors.bg0;

        background = colors.bg0;
        foreground = colors.fg0;
        line-size = 3;

        modules-left = "i3 sep xwindow";
        modules-right =
          "pulseaudio sep wlan sep memory temperature sep cpu loadavg sep battery sep date sep";
      };

      # Modules
      "module/sep" = {
        type = "custom/text";
        content = "|";
        content-foreground = colors.bg3;
        content-background = colors.bg0;
      };

      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "ADP1";
        full-at = "98";
        time-format = "%Hh%M";

        format-charging = "<animation-charging> <label-charging>";
        format-charging-underline = colors.quaternary;
        label-charging = "%percentage%+% (%time%)";

        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-underline = colors.quinary;
        label-discharging = "%percentage%% (%time%)";

        format-full-prefix = "ﮣ ";
        format-full = "AC";
        format-full-prefix-foreground = colors.fg1;
        format-full-underline = colors.quaternary;
        format-full-foreground = colors.secondary;

        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capacity-5 = "";
        ramp-capacity-6 = "";
        ramp-capacity-7 = "";
        ramp-capacity-8 = "";
        ramp-capacity-9 = "";
        ramp-capacity-10 = "";
        ramp-capacity-foreground = colors.fg1;

        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-foreground = colors.fg1;
        animation-charging-framerate = 500;
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "0.5";
        format-prefix = "  ";
        format-underline = colors.secondary;
        format = "<ramp-coreload>";

        ramp-coreload-0 = "▁";
        ramp-coreload-0-font = 5;
        ramp-coreload-0-foreground = colors.fg1;
        ramp-coreload-1 = "▂";
        ramp-coreload-1-font = 5;
        ramp-coreload-1-foreground = colors.fg1;
        ramp-coreload-2 = "▃";
        ramp-coreload-2-font = 5;
        ramp-coreload-2-foreground = colors.secondary;
        ramp-coreload-3 = "▄";
        ramp-coreload-3-font = 5;
        ramp-coreload-3-foreground = colors.secondary;
        ramp-coreload-4 = "▅";
        ramp-coreload-4-font = 5;
        ramp-coreload-4-foreground = colors.quinary;
        ramp-coreload-5 = "▆";
        ramp-coreload-5-font = 5;
        ramp-coreload-5-foreground = colors.quaternary;
        ramp-coreload-6 = "▇";
        ramp-coreload-6-font = 5;
        ramp-coreload-6-foreground = colors.alert;
        ramp-coreload-7 = "█";
        ramp-coreload-7-font = 5;
        ramp-coreload-7-foreground = colors.alert;
      };

      "module/date" = {
        type = "internal/date";
        interval = "5";

        date = " %a %d,";
        date-alt = " %Y-%m-%d";

        time = "%H:%M";
        time-alt = "%H:%M:%S";

        format-prefix = " ";
        format-prefix-foreground = colors.fg1;
        format-underline = colors.primary;

        label = "%date% %time%";
      };

      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = false;
        enable-scroll = false;
        # Only show workspaces on displayed monitor
        pin-workspaces = true;

        label-mode-padding = 1;
        label-mode-foreground = colors.bg0;
        label-mode-background = colors.primary;

        # focused = Active workspace on focused monitor
        label-focused = "%index%";
        label-focused-background = colors.bg3;
        label-focused-underline = colors.primary;
        label-focused-padding = 1;

        # unfocused = Inactive workspace on any monitor
        label-unfocused = "%index%";
        label-unfocused-padding = 1;

        # visible = Active workspace on unfocused monitor
        label-visible = "%index%";
        label-visible-padding = 1;

        # urgent = Workspace with alerting window
        label-urgent = "%index%";
        label-urgent-background = colors.alert;
        label-urgent-padding = 1;
      };

      "module/loadavg" = {
        type = "custom/script";
        exec = "${pkgs.coreutils}/bin/cut -d ' ' -f1,2,3 /proc/loadavg";
        interval = 5;
        format-prefix = " ";
        format-prefix-foreground = colors.fg1;
        format-underline = colors.secondary;
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 5;
        format-prefix = " ";
        format-prefix-foreground = colors.fg1;
        format-underline = colors.secondary;
        label = "%percentage_used%%, %gb_used%";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%percentage%%";
        label-volume-foreground = colors.fg1;
        format-underline = colors.tertiary;

        label-muted = "ﱝ --";
        label-muted-foreground = colors.fg3;

        ramp-volume-0 = "奄";
        ramp-volume-1 = "奔";
        ramp-volume-2 = "墳";
      };

      "module/temperature" = {
        type = "internal/temperature";
        thermal-zone = 6;
        warn-temperature = 75;

        format = "<ramp> <label>";
        format-underline = colors.secondary;
        format-warn = "<ramp> <label-warn>";
        format-warn-underline = colors.alert;

        label = "%temperature-c%";
        label-warn = "%temperature-c%";
        label-warn-foreground = colors.quinary;

        ramp-0 = "";
        ramp-1 = "";
        ramp-2 = "";
        ramp-3 = "";
        ramp-4 = "";
        ramp-foreground = colors.fg1;
      };

      "module/wlan" = {
        type = "internal/network";
        interface = "wlo1";
        interval = 3;

        format-connected = "直 <label-connected>";
        format-connected-underline = colors.tertiary;
        label-connected = "%signal%%";

        format-disconnected = " <label-disconnected>";
        format-disconnected-underline = colors.tertiary;
        label-disconnected = "%ifname%!";
        label-disconnected-foreground = colors.fg1;
        format-disconnected-background = colors.alert;

        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
        ramp-signal-foreground = colors.fg1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:50:...%";
      };
    };
  };
}
