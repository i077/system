{ config, lib, pkgs, ... }:

let
  colors = import ../colors.nix;
in lib.mkIf config.services.dunst.enable {
  services.dunst.settings = {
    global = {
      monitor = 0;
      follow = "mouse";

      # Appearance
      geometry = "800x5-30+30";
      shrink = "no";
      transparency = 10;
      notification_height = 0;
      separator_height = 2;
      padding = 16;
      horizontal_padding = 16;
      frame_width = 3;
      line_height = 0;

      frame_color = colors.primary;
      separator_color = "auto";

      font = "Jetbrains Mono 9";

      # Sort by urgency
      sort = true;
      indicate_hidden = true;

      # Don't remove messages if idle
      idle_threshold = 120;

      # Allow full markup
      markup = "full";

      # Formatting
      format = "<i>%a</i>\\n<b>%s</b>\\n%b\\n%p";
      alignment = "left";
      show_age_threshold = 60;
      word_wrap = true;

      ignore_newline = false;
      stack_duplicates = true;
      show_indicators = true;

      # Icon
      icon_position = "left";
      max_icon_size = 128;

      # History
      sticky_history = true;
      history_length = 25;

      dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst";
      title = "Dunst";
      class = "Dunst";
    };

    shortcuts = {
      close = "ctrl+space";
      close_all = "ctrl+shift+space";
      history = "mod4+n";
      context = "ctrl+shift+period";
    };

    urgency_low = {
      background = colors.bg0;
      foreground = colors.fg0;
      timeout = 15;
    };

    urgency_normal = {
      background = colors.bg2;
      foreground = colors.fg0;
      timeout = 15;
    };

    urgency_critical = {
      background = colors.alert;
      foreground = colors.fg0;
      timeout = 0;
    };
  };

  # Include testing script
  home.packages = [
    (pkgs.writeShellScriptBin "dunst-test" ''
      export PATH=${lib.makeBinPath [ pkgs.libnotify ]}
      notify-send -u critical "Test message: critical test 1"
      notify-send -u normal "Test message: normal test 2"
      notify-send -u low "Test message: low test 3"
      notify-send -u critical "Test message: critical test 4"
      notify-send -u normal "Test message: normal test 5"
      notify-send -u low "Test message: low test 6"
      notify-send -u critical "Test message: critical test 7"
      notify-send -u normal "Test message: normal test 8"
      notify-send -u low "Test message: low test 9"
    '')
  ];
}
